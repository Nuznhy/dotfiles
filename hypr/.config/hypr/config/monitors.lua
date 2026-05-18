local Mode = { DESKTOP = 1, TV = 2 }
local applying = false
local currentMode = Mode.DESKTOP

local desktopMon = {
    output = "DP-1",
    mode = "3840x2160@240.02",
    position = "0x0",
    scale = "1.25",
    vrr = false,
    bitdepth = 10,
}

local microMon = {
    output = "DP-2",
    mode = "960x640",
    position = "0x1728",
    scale = "1",
}

local tvMon = {
    output = "HDMI-A-1",
    mode = "3840x2160@60.0",
    disabled = true,
}

local function setMons()
    hl.monitor(tvMon)
    hl.monitor(desktopMon)
    hl.monitor(microMon)
end

local function toggleMons()
    if applying then
        return
    end

    applying = true

    if currentMode == Mode.DESKTOP then
        tvMon.disabled = false
        desktopMon.disabled = true
        microMon.disabled = true
        currentMode = Mode.TV
    else
        desktopMon.disabled = false
        microMon.disabled = false
        tvMon.disabled = true
        currentMode = Mode.DESKTOP
    end

    setMons()

    hl.notification.create({
        icon = "ok",
        timeout = 7500,
        text = tostring(currentMode),
    })

    applying = false
end

setMons()

return {
    toggleMons = toggleMons,
}
