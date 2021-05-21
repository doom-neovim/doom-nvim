return function()

    local plugins_count =
        Fn.len(Fn.globpath('~/.local/share/nvim/site/pack/packer/start', '*', 0, 1))

    G.dashboard_session_directory = Doom_root .. '/sessions'
    G.dashboard_default_executive = 'telescope'

    G.dashboard_custom_section = {
        a = {
            description = { '  Reload Last Session            SPC s r' },
            command = 'SessionLoad',
        },
        b = {
            description = { '  Recently Opened Files          SPC f h' },
            command = 'Telescope oldfiles',
        },
        c = {
            description = { '  Jump to Bookmark               SPC f b' },
            command = 'Telescope marks',
        },
        d = {
            description = { '  Find File                      SPC f f' },
            command = 'Telescope find_files',
        },
        e = {
            description = { '  Find Word                      SPC f g' },
            command = 'Telescope live_grep',
        },
        f = {
            description = { '  Open Private Configuration     SPC d c' },
            command = ':e ~/.config/nvim/doomrc',
        },
        g = {
            description = { '  Open Documentation             SPC d d' },
            command = ':h doom_nvim',
        },
    }

    G.dashboard_custom_footer = {
        'Doom Nvim loaded ' .. plugins_count .. ' plugins',
    }

    if not Doom.dashboard_statline then
        G.dashboard_disable_statusline = 1
    end

    G.dashboard_custom_header = Doom.dashboard_custom_header
    -- Header color
    Cmd(
        'hi! dashboardHeader   guifg='
            .. Doom.dashboard_custom_colors.header_color
    )
    Cmd(
        'hi! dashboardCenter   guifg='
            .. Doom.dashboard_custom_colors.center_color
    )
    Cmd(
        'hi! dashboardShortcut guifg='
            .. Doom.dashboard_custom_colors.shortcut_color
    )
    Cmd(
        'hi! dashboardFooter   guifg='
            .. Doom.dashboard_custom_colors.footer_color
    )
end
