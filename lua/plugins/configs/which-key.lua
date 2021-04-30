require('which-key').setup {
    plugins = {marks = false, registers = false},
    presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false
    },
    icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+' -- symbol prepended to a group
    },
    window = {
        border = 'none', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = {1, 0, 0, 0}, -- extra window margin [top, right, bottom, left]
        padding = {1, 1, 1, 1} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {'<silent>', '^:', '^ '}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}

