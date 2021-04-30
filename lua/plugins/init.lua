-- Manage vim global variables
local nvim_set_var = api.nvim_set_var

----- Plugins modules
-- Essentials         / (Plugin manager, vimpeccable, treesitter)
-- UI Related         / (All look-and-feel plugins)
-- Fuzzy Search       ! (Fuzzy searching)
-- Git Integration    + (Some git plugins like LazyGit)
-- Completion         + (Built-in LSP configurations)
-- File-related       + (EditorConfig, formatting, Tree-sitter, etc)
-- Web-related        + (Colorizer, emmet, rest client)
--
-- Legend:
--   ! : The group and its plugins cannot be disabled
--   / : The group cannot be disabled but some of its plugins can be
--   + : The group and its plugins can be disabled
--
-- NOTES:
--   1. You can disable an entire group or just some or their plugins based on
--        the legend, please refer to our documentation to learn how to do it.
--   2. We do not provide other LSP integration like coc.nvim,
--        please refer to our FAQ to see why.

--- Set disabled plugins modules and plugins
local disabled_plugins = {}
--- Disabled modules
local disabled_git = has_value(g.doom_disabled_modules, 'git')
local disabled_lsp = has_value(g.doom_disabled_modules, 'lsp')
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


    -----[[------------]]-----
    ---     UI Related     ---
    -----]]------------[[-----
    -- Fancy start screen
    -- cannot be disabled
    use {'glepnir/dashboard-nvim', disabled = false}

    -- Colorschemes
    -- cannot be disabled at the moment
    use {
        'sainnhe/sonokai', 'sainnhe/edge', 'sainnhe/everforest',
        'wadackel/vim-dogrun', 'joshdick/onedark.vim', 'ajmwagar/vim-deus'
    }

    -- File tree
    local disabled_tree = has_value(g.doom_disabled_plugins, 'tree')
    if disabled_tree then
        table.insert(disabled_plugins, 'tree')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons'},
        disabled = disabled_tree
    }

    -- Statusline
    -- can be disabled to use your own statusline
    local disabled_statusline = has_value(g.doom_disabled_plugins, 'statusline')
    if disabled_statusline then
        table.insert(disabled_plugins, 'statusline')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {'glepnir/galaxyline.nvim', disabled = disabled_statusline}

    -- Tabline
    -- can be disabled to use your own tabline
    local disabled_tabline = has_value(g.doom_disabled_plugins, 'tabline')
    if disabled_tabline then
        table.insert(disabled_plugins, 'tabline')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {'romgrk/barbar.nvim', disabled = disabled_tabline}

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
    use {'akinsho/nvim-toggleterm.lua', disabled = disabled_terminal}

    -- Viewer & finder for LSP symbols and tags
    local disabled_tagbar = has_value(g.doom_disabled_plugins, 'tagbar')
    if disabled_tagbar then
        table.insert(disabled_plugins, 'tagbar')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {'liuchengxu/vista.vim', disabled = disabled_tagbar}

    -- Minimap
    -- Depends on wfxr/code-minimap to work!
    local disabled_minimap = has_value(g.doom_disabled_plugins, 'minimap')
    if disabled_minimap then
        table.insert(disabled_plugins, 'minimap')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {'wfxr/minimap.vim', disabled = disabled_minimap}

    -- Keybindings menu like Emacs's guide-key
    -- cannot be disabled
    use {'folke/which-key.nvim', disabled = false}

    -- Distraction free environment
    local disabled_zen = has_value(g.doom_disabled_plugins, 'zen')
    if disabled_zen then
        table.insert(disabled_plugins, 'zen')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {'kdav5758/TrueZen.nvim', disabled = disabled_zen}


    -----[[--------------]]-----
    ---     Fuzzy Search     ---
    -----]]--------------[[-----
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        disable = false
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
        disable = (disabled_git and true or disabled_gitsigns)
    }

    -- LazyGit integration
    local disabled_lazygit = has_value(g.doom_disabled_plugins, 'lazygit')
    if disabled_git and (not disabled_lazygit) then
        table.insert(disabled_plugins, 'lazygit')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'kdheepak/lazygit.nvim',
        requires = {'nvim-lua/plenary.nvim'},
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
            {'ray-x/lsp_signature.nvim'}, {'onsails/lspkind-nvim'},
            {'norcalli/snippets.nvim'}
        },
        disable = (disabled_completion and true or disabled_compe)
    }

    -- provides the missing `:LspInstall` for `nvim-lspconfig`.
    local disabled_lspinstall = has_value(g.doom_disabled_plugins, 'lspinstall')
    if disabled_lsp and (not disabled_lspinstall) then
        table.insert(disabled_plugins, 'lspinstall')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use 'kabouzeid/nvim-lspinstall'


    -----[[--------------]]-----
    ---     File Related     ---
    -----]]--------------[[-----
    -- Write / Read files without permissions (e.g. /etc files) without having
    -- to use `sudo nvim /path/to/file`
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
    local disabled_indent_lines = has_value(g.doom_disabled_plugins,
                                            'indentlines')
    if disabled_files and (not disabled_indent_lines) then
        table.insert(disabled_plugins, 'indentlines')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'Yggdroot/indentLine',
        disable = (disabled_files and true or disabled_indent_lines)
    }

    -- EditorConfig support
    local disabled_editorconfig = has_value(g.doom_disabled_plugins,
                                            'editorconfig')
    if disabled_files and (not disabled_editorconfig) then
        table.insert(disabled_plugins, 'editorconfig')
        nvim_set_var('doom_disabled_plugins', disabled_plugins)
    end
    use {
        'editorconfig/editorconfig-vim',
        disable = (disabled_files and true or disabled_editorconfig)
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

    -- HTTP Client support
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
    use {'mattn/emmet-vim', disable = (disabled_web and true or disabled_emmet)}


    -----[[----------------]]-----
    ---     Custom Plugins     ---
    -----]]----------------[[-----
    -- If there are custom plugins then also require them
    for _, plug in pairs(g.doom_custom_plugins) do
        custom_plugins(plug)
    end
end)
