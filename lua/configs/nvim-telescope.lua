-- https://github.com/nvim-telescope/telescope.nvim#telescope-defaults
-- Required to close with ESC in insert mode
actions = require('telescope.actions')
telescope = require('telescope')

return function()
    telescope.setup{
        defaults = {
            mappings = {
                i = {
                    ['<esc>'] = actions.close
                }
            },
            vimgrep_arguments = {
                'rg',
                '--pretty',
                '--with-filename',
                '--column',
                '--smart-case'
            },
            prompt_position = "bottom",
            prompt_prefix = ">",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            layout_defaults = {
                -- TODO add builtin options.
            },
            file_sorter =  require'telescope.sorters'.get_fuzzy_file,
            file_ignore_patterns = {},
            generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
            shorten_path = true,
            winblend = 0,
            width = 0.75,
            preview_cutoff = 80,
            results_height = 1,
            results_width = 0.8,
            border = {},
            borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
            color_devicons = true,
            use_less = true,
            set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
            file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
            qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
        }
    }
end
