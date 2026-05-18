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
    name = "telegram-media-overlay",
    match = {
        class = "^(org.telegram.desktop)$",
        title = "^Media viewer$",
    },

    float = true,
    no_anim = true,
    no_shadow = true,
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
