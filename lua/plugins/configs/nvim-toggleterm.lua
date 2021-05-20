return function()
    require('toggleterm').setup({
        size = Doom.terminal_height,
        open_mapping = [[<c-t>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = true,
        persist_size = true,
        direction = Doom.terminal_direction,
        close_on_exit = true,
        float_opts = {
            border = 'curved',
            width = Doom.terminal_width,
            height = Doom.terminal_height,
            winblend = 0,
            highlights = {
                border = 'Special',
                background = 'Normal',
            },
        },
    })
end
