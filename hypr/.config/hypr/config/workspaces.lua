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
