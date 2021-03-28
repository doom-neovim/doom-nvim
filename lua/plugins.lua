-- Manage vim global variables
local g = vim.g
local nvim_set_var = vim.api.nvim_set_var

-- Useful function to see if the Vim variable have the value we are looking for
function has_value(tabl, val)
    for _, value in ipairs(tabl) do
        if value == val then
            return true
        end
    end

    return false
end

----- Plugins modules
-- Essentials,            ! cannot be disabled (Plugin manager, vimpeccable and languages)
-- UI Related,            / can be disabled    (All look-and-feel plugins)
-- Fuzzy Search (fuzzy),  + can be disabled    (Fuzzy search & more)
-- Git Integration (git), + can be disabled    (Some git plugins, including LazyGit)
-- Completion (lsp),      + can be disabled    (Built-in LSP configurations)
-- File-related (files),  + can be disabled    (EditorConfig, formatting, Tree-sitter, etc)
-- Web-related (web),     + can be disabled    (Colorizer, emmet, rest client)
--
-- Legend:
--   ! : The group and its plugins cannot be disabled
--   / : The group cannot be disabled but some of its plugins can be
--   + : The group and its plugins can be disabled
--
-- NOTES:
--   1. You can disable an entire group or just some or their plugins based on
--        the legend, please refer to our documentation to learn how to do it.
--   2. The UI dashboard depends on the Fuzzy Search group for
--        providing some features, but if you do not want to use them,
--        you can safely disable the Fuzzy Search group.
--   3. We do not provide other LSP integration like coc.nvim,
--        please refer to our FAQ to see why.

--- Set disabled plugins modules and plugins
local disabled_plugins = {}
--- Disabled modules
local disabled_fuzzy = has_value(g.doom_disabled_modules, 'fuzzy')
local disabled_git = has_value(g.doom_disabled_modules, 'git')
local disabled_completion = has_value(g.doom_disabled_modules, 'lsp')
local disabled_files = has_value(g.doom_disabled_modules, 'files')
local disabled_web = has_value(g.doom_disabled_modules, 'web')

local packer = require('packer')
return packer.startup(function()
    -----[[------------]]-----
    ---     Essentials     ---
    -----]]------------[[-----
    -- Plugins manager
    use 'wbthomason/packer.nvim'
    -- Auxiliar functions for using Lua in Neovim
    use 'svermeulen/vimpeccable'
    -- Languages support
    use 'sheerun/vim-polyglot'

    -----[[------------]]-----
    ---     UI Related     ---
    -----]]------------[[-----
    -- Fancy start screen
    -- cannot be disabled
    use {
        'glepnir/dashboard-nvim',
        disabled = false
    }
    -- Colorschemes
    -- cannot be disabled at the moment
    use {
        'sainnhe/sonokai',
        'sainnhe/edge',
        'sainnhe/everforest',
        'wadackel/vim-dogrun',
        'joshdick/onedark.vim',
        'ajmwagar/vim-deus'
    }
    -- File tree
    -- do not use the latest commit because it is broken, at least for me 
    local disabled_tree = has_value(g.doom_disabled_plugins, 'tree')
    if disabled_tree then
        table.insert(disabled_plugins, 'tree')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons' },
        commit = '491fd68d62cebd4a07642cc052028d9d3b55f62e',
        disabled = disabled_tree
    }
    -- Statusline
    -- can be disabled to use your own statusline
    local disabled_statusline = has_value(g.doom_disabled_plugins, 'statusline')
    if disabled_statusline then
        table.insert(disabled_plugins, 'statusline')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'glepnir/galaxyline.nvim',
        disabled = disabled_statusline
    }
    -- Tabline
    -- can be disabled to use your own tabline
    local disabled_tabline = has_value(g.doom_disabled_plugins, 'tabline')
    if disabled_tabline then
        table.insert(disabled_plugins, 'tabline')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'romgrk/barbar.nvim',
        disabled = disabled_tabline
    }
    -- Better splits
    -- NOTE: we are using this specific branch because the main still does not have
    -- the ignore filetypes feature, thanks to its owner per adding it <3 
    local disabled_focus = has_value(g.doom_disabled_plugins, 'focus')
    if disabled_focus then
        table.insert(disabled_plugins, 'focus')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'beauwilliams/focus.nvim',
        branch = 'cust_filetypes',
        disabled = disabled_focus
    }
    -- Better terminal
    -- can be disabled to use your own terminal plugin
    local disabled_terminal = has_value(g.doom_disabled_plugins, 'terminal')
    if disabled_terminal then
        table.insert(disabled_plugins, 'terminal')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'akinsho/nvim-toggleterm.lua',
        disabled = disabled_terminal
    }
    -- Viewer & finder for LSP symbols and tags
    local disabled_tagbar = has_value(g.doom_disabled_plugins, 'tagbar')
    if disabled_tagbar then
        table.insert(disabled_plugins, 'tagbar')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'liuchengxu/vista.vim',
        disabled = disabled_tagbar 
    }
    -- Minimap
    -- Depends on wfxr/code-minimap to work!
    local disabled_minimap = has_value(g.doom_disabled_plugins, 'minimap')
    if disabled_minimap then
        table.insert(disabled_plugins, 'minimap')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'wfxr/minimap.vim',
        disabled = disabled_minimap
    }
    -- Keybindings menu like Emacs's guide-key
    -- cannot be disabled
    use {
        'spinks/vim-leader-guide',
        disabled = false
    }
    -- Distraction free environment
    local disabled_goyo = has_value(g.doom_disabled_plugins, 'goyo')
    if disabled_goyo then
        table.insert(disabled_plugins, 'goyo')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'junegunn/goyo.vim',
        disabled = disabled_goyo
    }

    -----[[--------------]]-----
    ---     Fuzzy Search     ---
    -----]]--------------[[-----
    local disabled_telescope = has_value(g.doom_disabled_plugins, 'telescope')
    if disabled_fuzzy and (not disabled_telescope) then
        table.insert(disabled_plugins, 'telescope')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}
        },
        disable = (disabled_fuzzy and true or disabled_telescope)
    }

    -----[[-------------]]-----
    ---     GIT RELATED     ---
    -----]]-------------[[-----
    -- Git gutter better alternative, written in Lua
    -- can be disabled to use your own git gutter plugin
    local disabled_gitsigns = has_value(g.doom_disabled_plugins, 'gitsigns')
    if disabled_git and (not disabled_gitsigns) then
        table.insert(disabled_plugins, 'gitsigns')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'lewis6991/gitsigns.nvim',
        disable = (disabled_git and true or disabled_gitsigns),
    }
    -- LazyGit integration
    local disabled_lazygit = has_value(g.doom_disabled_plugins, 'lazygit')
    if disabled_git and (not disabled_lazygit) then
        table.insert(disabled_plugins, 'lazygit')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'kdheepak/lazygit.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        disable = (disabled_git and true or disabled_lazygit)
    }

    -----[[------------]]-----
    ---     Completion     ---
    -----]]------------[[-----
    -- Built-in LSP Config
    -- NOTE: It should not be disabled if you are going to use LSP!
    local disabled_lspconfig = has_value(g.doom_disabled_plugins, 'lspconfig')
    if disabled_lsp and (not disabled_lspconfig) then
        table.insert(disabled_plugins, 'lspconfig')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'neovim/nvim-lspconfig',
        commit = '11a581d1860a7ad2b6c1ee1e0ebbb000e81b9950',
        disable = (disabled_completion and true or disabled_lspconfig)
    }
    -- Completion plugin
    -- can be disabled to use your own completion plugin
    local disabled_compe = has_value(g.doom_disabled_plugins, 'compe')
    if disabled_lsp and (not disabled_compe) then
        table.insert(disabled_plugins, 'compe')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'hrsh7th/nvim-compe',
        requires = {
            {'ray-x/lsp_signature.nvim'}, {'onsails/lspkind-nvim'}, {'norcalli/snippets.nvim'}
        },
        disable = (disabled_completion and true or disabled_compe)
    }
    -----[[--------------]]-----
    ---     File Related     ---
    -----]]--------------[[-----
    -- Write / Read files without permissions (e.g. /etc files) without having to use `sudo nvim /path/to/file`
    local disabled_suda = has_value(g.doom_disabled_plugins, 'suda')
    if disabled_files and (not disabled_suda) then
        table.insert(disabled_plugins, 'suda')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'lambdalisue/suda.vim',
        disable = (disabled_files and true or disabled_suda)
    }
    -- File formatting
    -- can be disabled to use your own file formatter
    local disabled_neoformat = has_value(g.doom_disabled_plugins, 'neoformat')
    if disabled_files and (not disabled_neoformat) then
        table.insert(disabled_plugins, 'neoformat')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'sbdchd/neoformat',
        disable = (disabled_files and true or disabled_neoformat)
    }
    -- Autopairs
    -- can be disabled to use your own autopairs
    local disabled_autopairs = has_value(g.doom_disabled_plugins, 'autopairs')
    if disabled_files and (not disabled_autopairs) then
        table.insert(disabled_plugins, 'autopairs')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'windwp/nvim-autopairs',
        disable = (disabled_files and true or disabled_autopairs)
    }
    -- Indent Lines
    local disabled_indent_lines = has_value(g.doom_disabled_plugins, 'indentlines')
    if disabled_files and (not disabled_indent_lines) then
        table.insert(disabled_plugins, 'indentlines')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'Yggdroot/indentLine',
        disable = (disabled_files and true or disabled_indent_lines)
    }
    -- EditorConfig support
    local disabled_editorconfig = has_value(g.doom_disabled_plugins, 'editorconfig')
    if disabled_files and (not disabled_editorconfig) then
        table.insert(disabled_plugins, 'editorconfig')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'editorconfig/editorconfig-vim',
        disable = (disabled_files and true or disabled_editorconfig)
    }
    -- Tree-Sitter
    local disabled_treesitter = has_value(g.doom_disabled_plugins, 'treesitter')
    if disabled_files and (not disabled_treesitter) then
        table.insert(disabled_plugins, 'treesitter')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        disable = (disabled_files and true or disabled_treesitter)
    }
    -- Comments
    -- can be disabled to use your own comments plugin
    local disabled_kommentary = has_value(g.doom_disabled_plugins, 'kommentary')
    if disabled_files and (not disabled_kommentary) then
        table.insert(disabled_plugins, 'kommentary')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'b3nj5m1n/kommentary',
        disable = (disabled_files and true or disabled_kommentary)
    }

    -----[[-------------]]-----
    ---     Web Related     ---
    -----]]-------------[[-----
    -- Fastest colorizer without external dependencies!
    local disabled_colorizer = has_value(g.doom_disabled_plugins, 'colorizer')
    if disabled_web and (not disabled_colorizer) then
        table.insert(disabled_plugins, 'colorizer')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'norcalli/nvim-colorizer.lua',
        disable = (disabled_web and true or disabled_colorizer)
    }
    -- HTPP Client support
    -- Depends on bayne/dot-http to work!
    local disabled_restclient = has_value(g.doom_disabled_plugins, 'restclient')
    if disabled_web and (not disabled_restclient) then
        table.insert(disabled_plugins, 'restclient')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'bayne/vim-dot-http',
        disable = (disabled_web and true or disabled_restclient)
    }
    -- Emmet plugin
    local disabled_emmet = has_value(g.doom_disabled_plugins, 'emmet')
    if disabled_web and (not disabled_emmet) then
        table.insert(disabled_plugins, 'emmet')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'mattn/emmet-vim',
        disable = (disabled_web and true or disabled_emmet)
    }
    -----[[----------------]]-----
    ---     Custom Plugins     ---
    -----]]----------------[[-----
    -- If there are custom plugins
    for _, plugin in ipairs(g.doom_custom_plugins) do
        packer.use(plugin)
    end
end)
