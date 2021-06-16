return function()
	vim.g.indent_blankline_enabled = Doom.show_indent

	vim.g.indent_blankline_char_list = { '|', '¦', '┆', '┊' }

	-- If treesitter plugin is enabled then use its indentation
	if Check_plugin('nvim-treesitter') then
		vim.g.indent_blankline_use_treesitter = true
	end
	vim.g.indent_blankline_show_first_indent_level = false

	vim.g.indent_blankline_filetype_exclude = { 'dashboard' }
	vim.g.indent_blankline_buftype_exclude = { 'terminal' }
end
