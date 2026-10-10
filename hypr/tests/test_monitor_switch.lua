-- Run from the repository root: lua hypr/tests/test_monitor_switch.lua
package.path = "hypr/.config/hypr/?.lua;hypr/.config/hypr/?/init.lua;" .. package.path

local function session(tv_connected, incomplete_workspace, confirm_bind_fails, drop_empty_workspace)
    package.loaded["config.monitors"] = nil
    package.loaded["config.workspaces"] = nil
    local active = {
        ["DP-1"] = { name = "DP-1" },
        ["DP-2"] = { name = "DP-2" },
    }
    local workspaces = {
        { id = 1, monitor = active["DP-1"], special = false },
        { id = 7, monitor = active["DP-2"], special = false },
        { id = 9, monitor = active["DP-2"], special = false },
        { id = -1, monitor = active["DP-2"], special = true },
        { id = -2, name = "notes", monitor = active["DP-2"], special = false },
    }
    local windows = drop_empty_workspace and {}
        or { { pinned = true, monitor = active["DP-2"], workspace = workspaces[2] } }
    local rules, timers, focused, confirm_binding = {}, {}, workspaces[1], nil
    local active_monitor = active["DP-1"]
    active["DP-1"].active_workspace = workspaces[1]
    active["DP-2"].active_workspace = workspaces[2]
    local notifications = {}

    hl = {
        get_monitor = function(name) return active[name] end,
        get_workspaces = function() return workspaces end,
        get_windows = function() return windows end,
        get_workspace = function(id)
            for _, ws in ipairs(workspaces) do
                if ws.id == id or (type(id) == "string" and id == "name:" .. (ws.name or "")) then
                    return ws
                end
            end
        end,
        get_active_workspace = function() return focused end,
        monitor = function(spec)
            if spec.output == "HDMI-A-1" and not tv_connected then return end
            if spec.disabled then
                active[spec.output] = nil
                local destination = active["HDMI-A-1"] or active["DP-1"] or active["DP-2"]
                for _, ws in ipairs(workspaces) do
                    if ws.monitor and ws.monitor.name == spec.output then ws.monitor = destination end
                end
                for _, window in ipairs(windows) do
                    if window.monitor and window.monitor.name == spec.output then
                        window.monitor = destination
                    end
                end
                if spec.output == "DP-2" and drop_empty_workspace then
                    for index = #workspaces, 1, -1 do
                        if workspaces[index].id == 7 then table.remove(workspaces, index) end
                    end
                end
            else
                active[spec.output] = active[spec.output] or { name = spec.output }
                if spec.output == "HDMI-A-1" and incomplete_workspace then
                    workspaces[#workspaces + 1] = {
                        id = nil, name = "", special = false, monitor = active[spec.output]
                    }
                    incomplete_workspace = false
                end
            end
        end,
        workspace_rule = function(spec)
            local rule = { spec = spec, enabled = true }
            function rule:set_enabled(enabled) self.enabled = enabled end
            rules[#rules + 1] = rule
            return rule
        end,
        config = function() end,
        dispatch = function(dsp)
            if dsp.kind == "workspace" then
                if dsp.monitor == "HDMI-A-1" and active["DP-1"] then
                    error("workspace moved to TV before Desktop was disabled")
                end
                local ws = hl.get_workspace(dsp.workspace)
                ws.monitor = active[dsp.monitor]
                for _, window in ipairs(windows) do
                    if window.workspace == ws and not window.pinned then
                        window.monitor = ws.monitor
                    end
                end
            elseif dsp.kind == "window" then
                dsp.window.monitor = active[dsp.monitor]
            elseif dsp.kind == "focus" then
                if dsp.monitor then
                    active_monitor = active[dsp.monitor]
                    focused = active_monitor.active_workspace or focused
                elseif dsp.workspace then
                    local ws = hl.get_workspace(dsp.workspace)
                    if not ws then
                        ws = { id = dsp.workspace, name = tostring(dsp.workspace),
                            special = false, monitor = active_monitor }
                        workspaces[#workspaces + 1] = ws
                    elseif dsp.on_current_monitor then
                        ws.monitor = active_monitor
                    end
                    active_monitor = ws.monitor
                    active_monitor.active_workspace = ws
                    focused = ws
                end
            end
        end,
        dsp = {
            workspace = { move = function(args) args.kind = "workspace"; return args end },
            window = { move = function(args) args.kind = "window"; return args end },
            focus = function(args) args.kind = "focus"; return args end,
        },
        timer = function(callback)
            local timer = { enabled = true, callback = callback }
            function timer:set_enabled(enabled) self.enabled = enabled end
            timers[#timers + 1] = timer
            return timer
        end,
        bind = function(key, callback)
            assert(key == "Return")
            if confirm_bind_fails then error("could not bind Enter") end
            confirm_binding = { callback = callback, enabled = true }
            function confirm_binding:remove() self.enabled = false end
            return confirm_binding
        end,
        notification = { create = function(args) notifications[#notifications + 1] = args end },
    }
    local controller = require("config.monitors")
    require("config.workspaces")
    local function advance(limit)
        for _ = 1, limit do
            if not timers[1].enabled then return end
            timers[1].callback()
        end
    end
    return {
        active = active, workspaces = workspaces, windows = windows, rules = rules,
        notifications = notifications, controller = controller, advance = advance,
        focused = function() return focused end,
        confirm_enter = function()
            assert(confirm_binding and confirm_binding.enabled)
            confirm_binding.callback()
        end,
        tick_watchdog = function() timers[2].callback() end,
        unplug_tv = function()
            active["HDMI-A-1"] = nil
            timers[2].callback()
        end,
    }
end

local s = session(true)
s.controller.toggleMons()
s.controller.toggleMons() -- A repeated hotkey cannot start a second transition.
s.advance(10)
assert(s.active["HDMI-A-1"] and not s.active["DP-1"] and not s.active["DP-2"])
for _, ws in ipairs(s.workspaces) do assert(ws.monitor.name == "HDMI-A-1") end
assert(s.windows[1].monitor.name == "HDMI-A-1")
assert(s.controller.pending_confirmation)
for _, rule in ipairs(s.rules) do
    if rule.spec.monitor then assert(not rule.enabled) end
end
s.confirm_enter()
assert(not s.controller.pending_confirmation)
s.workspaces[#s.workspaces + 1] = { id = 10, monitor = s.active["HDMI-A-1"], special = false }
s.controller.toggleMons()
s.advance(25)
assert(s.active["DP-1"] and s.active["DP-2"] and not s.active["HDMI-A-1"])
assert(s.workspaces[1].monitor.name == "DP-1")
assert(s.workspaces[2].monitor.name == "DP-2")
assert(s.workspaces[3].monitor.name == "DP-2")
assert(s.workspaces[5].monitor.name == "DP-2")
assert(s.workspaces[6].monitor.name == "DP-1")
assert(s.focused().id == 1)
for _, rule in ipairs(s.rules) do
    if rule.spec.monitor then assert(rule.enabled) end
end

local disconnected = session(false)
disconnected.controller.toggleMons()
disconnected.advance(125)
assert(disconnected.active["DP-1"] and disconnected.active["DP-2"])
assert(not disconnected.active["HDMI-A-1"])
assert(disconnected.notifications[#disconnected.notifications].icon == "err")

local unplugged = session(true)
unplugged.controller.toggleMons()
unplugged.advance(10)
unplugged.unplug_tv()
unplugged.advance(25)
assert(unplugged.active["DP-1"] and unplugged.active["DP-2"])
assert(unplugged.workspaces[1].monitor.name == "DP-1")

local incomplete = session(true, true)
incomplete.controller.toggleMons()
incomplete.advance(10)
assert(incomplete.active["HDMI-A-1"] and not incomplete.active["DP-1"])

local unconfirmed = session(true)
unconfirmed.controller.toggleMons()
unconfirmed.advance(10)
unconfirmed.advance(155)
unconfirmed.advance(25)
assert(unconfirmed.active["DP-1"] and not unconfirmed.active["HDMI-A-1"])

local cancelled = session(true)
cancelled.controller.toggleMons()
cancelled.advance(10)
cancelled.controller.toggleMons()
cancelled.advance(25)
assert(cancelled.active["DP-1"] and not cancelled.active["HDMI-A-1"])

local bind_failure = session(true, false, true)
bind_failure.controller.toggleMons()
bind_failure.advance(10)
-- The watchdog retries Desktop if confirmation setup itself fails.
bind_failure.tick_watchdog()
bind_failure.advance(25)
assert(bind_failure.active["DP-1"] and not bind_failure.active["HDMI-A-1"])

local empty = session(true, false, false, true)
empty.controller.toggleMons()
empty.advance(10)
empty.confirm_enter()
empty.controller.toggleMons()
empty.advance(25)
assert(empty.active["DP-2"].active_workspace
    and empty.active["DP-2"].active_workspace.id == 7,
    "DP-2 active workspace missing: " .. tostring(empty.controller.last_error))
assert(empty.focused().id == 1)
print("monitor switch tests passed")
