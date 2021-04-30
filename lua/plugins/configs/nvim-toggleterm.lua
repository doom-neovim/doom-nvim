require('toggleterm').setup({
	size = g.doom_terminal_height,
	open_mapping = [[<c-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	start_in_insert = true,
	persist_size = true,
	direction = g.doom_terminal_direction,
	float_opts = {
		border = 'curved',
		width = g.doom_terminal_width,
		height = g.doom_terminal_height,
		winblend = 0,
		highlights = {
			border = 'Special',
			background = 'Normal',
		},
	},
})
