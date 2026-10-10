local desktopMon = {
    output = "DP-1", mode = "3840x2160@240", position = "0x0",
    scale = "1.5", vrr = false, bitdepth = 10, cm = "srgb",
    sdrbrightness = 1.2, sdrsaturation = 1,
}

-- local desktopMon = {
--     output = "DP-1", mode = "1920x1080@480", position = "0x0",
--     scale = "1", vrr = false, bitdepth = 10,
-- }

local microMon = { output = "DP-2", mode = "960x640", position = "0x1728", scale = "1" }
local tvMon = { output = "HDMI-A-1", mode = "3840x2160@60.0", scale = "2", disabled = true, bitdepth = 10 }

local applying, stage, ticks = false, nil, 0
local snapshot, visible_workspaces, focused_workspace, timer, confirm_bind
local begin_desktop
local controller = { last_error = "", pending_confirmation = false, restore_requested = false }

local function monitor(name)
    return hl.get_monitor(name)
end

local function notify(message, icon)
    hl.notification.create({ text = message, icon = icon or "info", timeout = 5000 })
end

local function clear_confirmation()
    controller.pending_confirmation = false
    if confirm_bind then
        pcall(function() confirm_bind:remove() end)
        confirm_bind = nil
    end
end

local function set_monitor(spec, enabled)
    spec.disabled = not enabled
    hl.monitor(spec)
end

local function workspace_selector(ws)
    if type(ws.id) == "number" and ws.id > 0 then return ws.id end
    if type(ws.name) == "string" and ws.name ~= "" and not ws.special then
        return "name:" .. ws.name
    end
    return nil
end

local function workspace_map()
    local result = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        local selector = workspace_selector(ws)
        if selector and not ws.special and ws.monitor then
            result[selector] = ws.monitor.name
        end
    end
    return result
end

local function move_workspaces(destinations)
    for _, ws in ipairs(hl.get_workspaces()) do
        local selector = workspace_selector(ws)
        if selector and not ws.special then
            local name = destinations[selector]
            if name and monitor(name) and (not ws.monitor or ws.monitor.name ~= name) then
                hl.dispatch(hl.dsp.workspace.move({ workspace = selector, monitor = name }))
            end
        end
    end
end

local function move_everything_to_tv()
    local destinations = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        local selector = workspace_selector(ws)
        if selector and not ws.special then destinations[selector] = tvMon.output end
    end
    move_workspaces(destinations)
    -- Pinned windows may stay on their old output after their workspace moves.
    for _, window in ipairs(hl.get_windows()) do
        if window.pinned and window.monitor and window.monitor.name ~= tvMon.output then
            hl.dispatch(hl.dsp.window.move({ window = window, monitor = tvMon.output }))
        end
    end
end

local function desktop_destinations()
    local destinations = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        local selector = workspace_selector(ws)
        if selector and not ws.special then
            local saved = snapshot and snapshot[selector]
            local on_micro = (saved == microMon.output or (not saved and ws.id == 9))
                and monitor(microMon.output)
            destinations[selector] = on_micro and microMon.output or desktopMon.output
        end
    end
    return destinations
end

local function restore_desktop()
    local destinations = desktop_destinations()
    move_workspaces(destinations)
    for _, window in ipairs(hl.get_windows()) do
        local destination = window.workspace and destinations[workspace_selector(window.workspace)]
        if window.pinned and destination and window.monitor
            and window.monitor.name ~= destination then
            hl.dispatch(hl.dsp.window.move({ window = window, monitor = destination }))
        end
    end
end

local function restore_active_workspaces()
    for _, name in ipairs({ desktopMon.output, microMon.output }) do
        local current_monitor = monitor(name)
        local selector = visible_workspaces and visible_workspaces[name]
        if current_monitor and selector
            and workspace_selector(current_monitor.active_workspace or {}) ~= selector then
            hl.dispatch(hl.dsp.focus({ monitor = name }))
            hl.dispatch(hl.dsp.focus({ workspace = selector, on_current_monitor = true }))
        end
    end
end

local function workspaces_on_desktop()
    for id, name in pairs(desktop_destinations()) do
        local ws = hl.get_workspace(id)
        if ws and ws.monitor and ws.monitor.name ~= name then return false end
    end
    for name, selector in pairs(visible_workspaces or {}) do
        local current_monitor = monitor(name)
        if current_monitor
            and workspace_selector(current_monitor.active_workspace or {}) ~= selector then
            return false
        end
    end
    return true
end

local function no_stranded_windows()
    for _, window in ipairs(hl.get_windows()) do
        if window.monitor and not monitor(window.monitor.name) then return false end
    end
    return true
end

local function focus_saved()
    if focused_workspace and hl.get_workspace(focused_workspace) then
        hl.dispatch(hl.dsp.focus({ workspace = focused_workspace }))
    end
end

local function finish(mode)
    clear_confirmation()
    timer:set_enabled(false)
    applying, stage = false, nil
    controller.restore_requested = false
    if mode == "desktop" then snapshot, visible_workspaces = nil, nil end
    notify(mode == "tv" and "TV layout ready" or "Desktop layout ready", "ok")
end

local function recover(reason)
    clear_confirmation()
    timer:set_enabled(false)
    controller.last_error = tostring(reason)
    local function attempt(action)
        local ok, recovery_error = pcall(action)
        if not ok then
            controller.last_error = controller.last_error .. "; recovery: " .. tostring(recovery_error)
        end
    end
    -- Never disable the only output Hyprland still sees.
    if monitor(desktopMon.output) then
        attempt(function() set_monitor(desktopMon, true) end)
        attempt(function() set_monitor(microMon, true) end)
        attempt(function() require("config.workspaces").set_monitor_rules(true) end)
        attempt(restore_desktop)
        attempt(restore_active_workspaces)
        attempt(focus_saved)
        attempt(function() set_monitor(tvMon, false) end)
        snapshot, visible_workspaces = nil, nil
        controller.restore_requested = false
    elseif monitor(tvMon.output) then
        if controller.restore_requested then
            -- Keep trying to bring Desktop back after an unconfirmed TV switch.
            attempt(function() set_monitor(desktopMon, true) end)
            attempt(function() set_monitor(microMon, true) end)
        else
            attempt(function() require("config.workspaces").set_monitor_rules(false) end)
            attempt(move_everything_to_tv)
            attempt(function() set_monitor(microMon, false) end)
            attempt(function() set_monitor(desktopMon, false) end)
        end
    else
        -- An output may still be waking up. Restore the known Desktop rules.
        attempt(function() set_monitor(desktopMon, true) end)
        attempt(function() set_monitor(microMon, true) end)
        attempt(function() require("config.workspaces").set_monitor_rules(true) end)
        attempt(function() set_monitor(tvMon, false) end)
    end
    applying, stage = false, nil
    notify("Display switch failed: " .. controller.last_error, "err")
end

local function step()
    ticks = ticks + 1
    if stage == "confirm_tv" then
        if not monitor(tvMon.output) then
            begin_desktop()
        elseif ticks >= 150 then
            notify("TV was not confirmed; restoring Desktop", "warn")
            begin_desktop()
        end
        return
    end
    if ticks > 120 then error("display did not become ready") end

    if stage == "wait_tv" then
        if not monitor(tvMon.output) then return end
        -- Let Hyprland migrate workspaces as it did with the original switch.
        -- Moving them while all outputs are still active can leave the TV blank.
        controller.restore_requested = true
        set_monitor(desktopMon, false)
        set_monitor(microMon, false)
        stage = "verify_tv"
    elseif stage == "verify_tv" then
        if not monitor(tvMon.output) then error("TV disappeared") end
        if monitor(desktopMon.output) or monitor(microMon.output) then return end
        for _, ws in ipairs(hl.get_workspaces()) do
            if ws.monitor and ws.monitor.name ~= tvMon.output then
                move_everything_to_tv()
                return
            end
        end
        if not no_stranded_windows() then error("a window stayed on a disabled display") end
        focus_saved()
        stage, ticks = "confirm_tv", 0
        controller.pending_confirmation = true
        confirm_bind = hl.bind("Return", function() controller.confirmTv() end)
        notify("TV active: press Enter within 15 seconds to keep it", "warn")
    elseif stage == "wait_desktop" then
        if not monitor(desktopMon.output) then return end
        -- DP-2 is optional when unplugged; allow it time to wake.
        if not monitor(microMon.output) and ticks < 20 then return end
        restore_desktop()
        restore_active_workspaces()
        stage = "move_desktop"
    elseif stage == "move_desktop" then
        if not workspaces_on_desktop() then
            restore_desktop()
            restore_active_workspaces()
            return
        end
        require("config.workspaces").set_monitor_rules(true)
        focus_saved()
        set_monitor(tvMon, false)
        stage = "verify_desktop"
    elseif stage == "verify_desktop" then
        if not monitor(desktopMon.output) then error("desktop display disappeared") end
        if monitor(tvMon.output) then return end
        restore_desktop()
        restore_active_workspaces()
        if not workspaces_on_desktop() then return end
        if not no_stranded_windows() then error("a window stayed on a disabled display") end
        focus_saved()
        finish("desktop")
    end
end

timer = hl.timer(function()
    local ok, reason = pcall(step)
    if not ok then
        local recovered, recovery_error = pcall(recover, reason)
        if not recovered then
            timer:set_enabled(false)
            applying = false
            notify("Display recovery failed: " .. tostring(recovery_error), "err")
        end
    end
end, { timeout = 100, type = "repeat" })
timer:set_enabled(false)

begin_desktop = function()
    clear_confirmation()
    controller.restore_requested = true
    applying, ticks = true, 0
    set_monitor(desktopMon, true)
    set_monitor(microMon, true)
    stage = "wait_desktop"
    timer:set_enabled(true)
end

-- If the TV is unplugged while it owns all workspaces, bring the desktop back.
local watchdog = hl.timer(function()
    if snapshot and not applying
        and (controller.restore_requested or not monitor(tvMon.output)) then
        local ok, reason = pcall(begin_desktop)
        if not ok then recover(reason) end
    end
end, { timeout = 1000, type = "repeat" })

local function toggleMons()
    if stage == "confirm_tv" then
        local ok, reason = pcall(begin_desktop)
        if not ok then recover(reason) end
        return
    end
    if applying then return end
    local desktop_active = monitor(desktopMon.output) ~= nil
    local tv_active = monitor(tvMon.output) ~= nil
    if desktop_active == tv_active then
        notify("Display layout is changing or unavailable; try again shortly", "warn")
        return
    end

    applying, ticks = true, 0
    controller.last_error = ""
    local ok, reason = pcall(function()
        if desktop_active then
            snapshot = workspace_map()
            visible_workspaces = {}
            for _, name in ipairs({ desktopMon.output, microMon.output }) do
                local current_monitor = monitor(name)
                local active = current_monitor and current_monitor.active_workspace
                if active then visible_workspaces[name] = workspace_selector(active) end
            end
            local focused = hl.get_active_workspace()
            focused_workspace = focused and workspace_selector(focused) or nil
            require("config.workspaces").set_monitor_rules(false)
            set_monitor(tvMon, true)
            stage = "wait_tv"
        else
            begin_desktop()
        end
        timer:set_enabled(true)
    end)
    if not ok then recover(reason) end
end

local function confirmTv()
    if stage ~= "confirm_tv" or not monitor(tvMon.output) then return false end
    finish("tv")
    return true
end

-- A reload intentionally restores Desktop mode.
hl.monitor(tvMon)
hl.monitor(desktopMon)
hl.monitor(microMon)

controller.toggleMons = toggleMons
controller.confirmTv = confirmTv
controller._watchdog = watchdog
return controller
