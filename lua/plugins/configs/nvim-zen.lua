return function()
	require('true-zen').setup({
		true_false_commands = false,
		cursor_by_mode = false,
		bottom = {
			hidden_laststatus = 0,
			hidden_ruler = true,
			hidden_showmode = true,
			hidden_showcmd = true,
			hidden_cmdheight = 1,

			shown_laststatus = 2,
			shown_ruler = false,
			shown_showmode = false,
			shown_showcmd = false,
			shown_cmdheight = 1,
		},
		top = {
			hidden_showtabline = 0,

			shown_showtabline = 2,
		},
		left = {
			hidden_number = false,
			hidden_relativenumber = false,
			hidden_signcolumn = 'no',

			shown_number = true,
			shown_relativenumber = false,
			shown_signcolumn = 'no',
		},
		ataraxis = {
			ideal_writing_area_width = 0,
			just_do_it_for_me = true,
			left_padding = 40,
			right_padding = 40,
			top_padding = 0,
			bottom_padding = 0,
			custome_bg = '',
			disable_bg_configuration = false,
			disable_fillchars_configuration = false,
			keep_default_fold_fillchars = true,
			force_when_plus_one_window = false,
			force_hide_statusline = true,
			quit_untoggles_ataraxis = true,
		},
		focus = {
			margin_of_error = 5,
			focus_method = 'experimental',
		},
		minimalist = {
			store_and_restore_settings = true,
		},
		events = {
			before_minimalist_mode_shown = false,
			before_minimalist_mode_hidden = false,
			after_minimalist_mode_shown = false,
			after_minimalist_mode_hidden = false,

			before_focus_mode_focuses = false,
			before_focus_mode_unfocuses = false,
			after_focus_mode_focuses = false,
			after_focus_mode_unfocuses = false,
		},
		integrations = {
			integration_galaxyline = true,
			integration_gitsigns = true,
		},
	})
end
