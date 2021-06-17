return function()
	require('nvim-autopairs').setup({
		check_ts = has_value(Doom.disabled_plugins, 'treesitter'),
		enable_afterquote = true,
		enable_moveright = true,
		enable_check_bracket_line = true,
	})
end
