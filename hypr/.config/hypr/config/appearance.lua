hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
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
