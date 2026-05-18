local WS = 1
local CLASS = "com.mitchellh.ghostty"

local function dispatch_float(w)
  hl.dispatch(hl.dsp.window.float({
    action = "enable",
    window = w,
  }))

  local m = hl.get_monitor(w.monitor)
  if m ~= nil then
    hl.dispatch(hl.dsp.window.resize({
      x = math.floor(m.width * 0.65),
      y = math.floor(m.height * 0.75),
      window = w,
    }))
  end

  hl.dispatch(hl.dsp.window.center({
    window = w,
  }))
end

local function dispatch_tile(w)
  hl.dispatch(hl.dsp.window.float({
    action = "disable",
    window = w,
  }))
end

local function update_workspace()
  local windows = hl.get_workspace_windows(WS)

  if #windows == 1 then
    local w = windows[1]

    if w.class == CLASS then
      dispatch_float(w)
    end

  elseif #windows > 1 then
    for _, w in ipairs(windows) do
      if w.floating then
        dispatch_tile(w)
      end
    end
  end
end

-- Re-check whenever the relevant window/workspace state changes
hl.on("hyprland.start", update_workspace)
hl.on("window.open", update_workspace)
hl.on("window.close", update_workspace)
hl.on("window.destroy", update_workspace)
hl.on("window.move_to_workspace", update_workspace)
hl.on("workspace.active", update_workspace)
hl.on("config.reloaded", update_workspace)
