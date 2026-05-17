hl.env("ENCHANT_CONFIG_DICT", "en_US,uk_UA")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("GDK_SCALE", 2)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", 2)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

------------------
---- MONITORS ----
------------------
local Mode = { DESKTOP = 1, TV = 2, }
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
    mode = "3840x2160@60.0",
    output = "HDMI-A-1",
    disabled = true
}
local function setMons()
    hl.monitor(tvMon)
    hl.monitor(desktopMon)
    hl.monitor(microMon)
end

setMons()

local terminal = "ghostty"
local fileManager = "nautilus"
local ipc = "qs -c noctalia-shell ipc call"
local menu = 'rofi -show drun -show-icons -display-drun ""'


-------------------
---- AUTOSTART ----
-------------------
hl.on('hyprland.start', function()
    hl.exec_cmd("qs -c noctalia-shell --no-duplicate")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("openrgb --server --startminimized --profile pink.orp")
    hl.exec_cmd("wl-paste --watch cliphis store")
    hl.exec_cmd("syncthing --no-browser")

    -- Apps --
    hl.exec_cmd(terminal .. " -e zsh -c '$HOME/bin/fastfetch-random; exec zsh -i'")
    hl.exec_cmd('zen-browser')
    hl.exec_cmd('discord')
    hl.exec_cmd('spotify')
    hl.exec_cmd('Telegram')

    hl.exec_cmd("systemctl --user restart hypr-tiling-fix.service")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in          = 10,
        gaps_out         = 10,
        border_size      = 2,

        col              = {
            active_border   = { colors = { "rgba(eb6f92ee)", "rgba(8839efee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,
        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 15,
        rounding_power   = 5,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow           = {
            enabled      = true,
            range        = 5,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur             = {
            enabled                   = true,
            size                      = 5,
            passes                    = 2,
            xray                      = false,
            special                   = false,
            new_optimizations         = true,
            brightness                = 1,
            noise                     = 0.4,
            contrast                  = 0.8,
            vibrancy                  = 0.5,
            vibrancy_darkness         = 0.5,
            popups                    = true,
            popups_ignorealpha        = 0.6,
            input_methods             = true,
            input_methods_ignorealpha = 0.8,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

hl.workspace_rule({ workspace = "1", monitor = 'DP-1' })
hl.workspace_rule({ workspace = "2", layout = 'master', monitor = 'DP-1' })
hl.workspace_rule({ workspace = "3", layout = 'master', monitor = 'DP-1' })
hl.workspace_rule({ workspace = "4", monitor = 'DP-1' })
hl.workspace_rule({ workspace = "5", monitor = 'DP-1' })
hl.workspace_rule({ workspace = "6", monitor = 'DP-1' })
hl.workspace_rule({ workspace = "9", monitor = 'DP-2' })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us,ua",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "grp:caps_toggle",
        kb_rules     = "",
        repeat_rate  = 35,
        repeat_delay = 250,
        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad     = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


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

    -- update monitor config
    setMons()

    hl.notification.create({
        icon = "ok",
        timeout = 7500,
        text = currentMode
    })

    applying = false
end

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + SHIFT + F2", toggleMons)

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy --type image/png'))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))


hl.bind(mainMod .. " + CTRL + R", hl.dsp.submap("resize"))

-- Start a submap called "resize".
hl.define_submap("resize", function()
    -- Set repeating binds for resizing the active window.
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Swapping and toggling splits
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + space", hl.dsp.layout("togglesplit"))


-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "zen-position",
    match = { class = "^(zen)$" },
    workspace = 2
})

hl.window_rule({
    name = "discord-position",
    match = { class = "^(discord)$" },
    workspace = 3
})

hl.window_rule({
    name = "spotify-position",
    match = { class = "^(Spotify)$" },
    workspace = 3
})

hl.window_rule({
    name = "telegram-position",
    match = { class = "^(org.telegram.desktop)$" },
    workspace = 3
})

hl.window_rule({
    name = "telegram-no-anim",
    match = { class = "^(org.telegram.desktop)$", title = "^(Media viewer)$" },
    no_anim = true,
    float = true,
    no_shadow = true
})

hl.window_rule({
    name = 'ghostty-position-opacity',
    match = {
        class = "^(com.mitchellh.ghostty)$"
    },
    opacity = "0.9 override 0.9 override 0.9 override",
    size = "(monitor_w*0.8) (monitor_h*0.95)",
    workspace = 1,
    float = true,
    center = true
})

hl.window_rule({
    name = 'calc-float',
    float = true,
    match = {
        class = "^(org.gnome.Calculator)$"
    }
})

hl.window_rule({
    name = "steam-float",
    float = true,
    match = { class = "(^steam$|^Steam$|steamwebhelper)" }
})


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
