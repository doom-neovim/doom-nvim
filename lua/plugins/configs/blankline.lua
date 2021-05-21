return function()
    G.indent_blankline_enabled = Doom.show_indent

    G.indent_blankline_char_list = { '|', '¦', '┆', '┊' }

    -- If treesitter plugin is enabled then use its indentation
    if Check_plugin('nvim-treesitter') then
        G.indent_blankline_use_treesitter = true
    end
    G.indent_blankline_show_first_indent_level = false

    G.indent_blankline_filetype_exclude = { 'dashboard' }
    G.indent_blankline_buftype_exclude = { 'terminal' }
end
