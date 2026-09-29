local laptopMon = {
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "auto",
    scale = "1",
    vrr = false,
    bitdepth = 10,
    cm = "srgb",
    sdrbrightness = 1.2,
    sdrsaturation = 1,
}

local desktopMon = {
    output = "HDMI-A-1",
    mode = "2560x1440@144",
    position = "auto-right",
    scale = "1",
    vrr = false,
    bitdepth = 10,
}

-- local desktopMon = {
--     output = "HDMI-A-1",
--     mode = "3840x2160@240",
--     position = "auto-left",
--     scale = "1.5",
--     vrr = false,
--     bitdepth = 10,
-- }

local function setMons()
    hl.monitor(laptopMon)
    hl.monitor(desktopMon)
end

setMons()
