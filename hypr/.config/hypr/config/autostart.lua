return function(vars)
    hl.on("hyprland.start", function()
        hl.exec_cmd("qs -c noctalia-shell --no-duplicate")
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("openrgb --server --startminimized --profile pink.orp")
        hl.exec_cmd("wl-paste --watch cliphis store")

        hl.exec_cmd(vars.terminal .. " -e zsh -c '$HOME/bin/fastfetch-random; exec zsh -i'")
        hl.exec_cmd("zen-browser")
        hl.exec_cmd("discord")
        hl.exec_cmd("spotify")
        hl.exec_cmd("Telegram")
    end)
end
