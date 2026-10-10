local monitor_rules = {}
for _, id in ipairs({ 1, 2, 3, 4, 5, 6 }) do
    monitor_rules[#monitor_rules + 1] = hl.workspace_rule({ workspace = tostring(id), monitor = 'DP-1' })
end
monitor_rules[#monitor_rules + 1] = hl.workspace_rule({ workspace = "9", monitor = 'DP-2' })

-- Layout choices must remain in effect while monitor placement rules are paused.
hl.workspace_rule({ workspace = "2", layout = 'master' })
hl.workspace_rule({ workspace = "3", layout = 'master' })

local function set_monitor_rules(enabled)
    for _, rule in ipairs(monitor_rules) do
        rule:set_enabled(enabled)
    end
end

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

return { set_monitor_rules = set_monitor_rules }
