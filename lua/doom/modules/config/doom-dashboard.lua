return function()
	vim.g.dashboard_session_directory = require('doom.utils').doom_root .. '/sessions'
	vim.g.dashboard_default_executive = 'telescope'

	vim.g.dashboard_custom_section = {
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
			command = ':e ~/.config/doom-nvim/doomrc',
		},
		g = {
			description = { '  Open Documentation             SPC d d' },
			command = ':h doom_nvim',
		},
	}

	vim.g.dashboard_custom_footer = {
		'Doom Nvim loaded in ' .. vim.fn.printf(
			'%.3f',
			vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
		) .. ' seconds.',
	}

	if not Doom.dashboard_statline then
		vim.g.dashboard_disable_statusline = 1
	end

	vim.g.dashboard_custom_header = Doom.dashboard_custom_header
	-- Header color
	vim.cmd(
		'hi! dashboardHeader   guifg='
			.. Doom.dashboard_custom_colors.header_color
	)
	vim.cmd(
		'hi! dashboardCenter   guifg='
			.. Doom.dashboard_custom_colors.center_color
	)
	vim.cmd(
		'hi! dashboardShortcut guifg='
			.. Doom.dashboard_custom_colors.shortcut_color
	)
	vim.cmd(
		'hi! dashboardFooter   guifg='
			.. Doom.dashboard_custom_colors.footer_color
	)
end
