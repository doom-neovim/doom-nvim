-- Manage vim global variables
g = vim.g

-- Useful function to see if the Vim variable have the value we are looking for
function has_value(tabl, val)
    for _, value in ipairs(tabl) do
        if value == val then
            return true
        end
    end

    return false
end

-- Required if you have packer in your `opt` pack
-- /home/user/.local/share/nvim/site/pack/packer/opt
vim.cmd [[packadd packer.nvim]]

----- Plugins groups
-- Essentials,      ! cannot be disabled (Plugin manager, vimpeccable and languages)
-- UI Related,      / can be disabled    (All look-and-feel plugins)
-- Fuzzy Search,    + can be disabled    (Fuzzy search & more)
-- Git Integration, + can be disabled    (Some git plugins, including LazyGit)
-- Completion,      + can be disabled    (Built-in LSP configurations)
-- File-related,    + can be disabled    (EditorConfig, formatting, Tree-sitter, etc)
-- Web-related,     + can be disabled    (Colorizer, emmet, http client)
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
return require('packer').startup(function()
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
        'wadackel/vim-dogrun',
        'joshdick/onedark.vim'
    }
    -- File tree
    -- do not use the latest commit because it is broken, at least for me
    use {
        'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons' },
        commit = '491fd68d62cebd4a07642cc052028d9d3b55f62e',
        disabled = has_value(g.doom_disabled_plugins, 'nvim-tree.lua')
    }
    -- Statusline
    -- can be disabled to use your own statusline
    use {
        'glepnir/galaxyline.nvim',
        disabled = has_value(g.doom_disabled_plugins, 'galaxyline.nvim')
    }
    -- Tabline
    -- can be disabled to use your own tabline
    use {
        'romgrk/barbar.nvim',
        disabled = has_value(g.doom_disabled_plugins, 'barbar.nvim')
    }
    -- Better splits
    -- NOTE: we are using this specific branch because the main still does not have
    -- the ignore filetypes feature, thanks to its owner per adding it <3
    use {
        'beauwilliams/focus.nvim',
        branch = 'cust_filetypes',
        disabled = has_value(g.doom_disabled_plugins, 'focus.nvim')
    }
    -- Better terminal
    -- can be disabled to use your own terminal plugin
    use {
        'akinsho/nvim-toggleterm.lua',
        disabled = has_value(g.doom_disabled_plugins, 'nvim-toggleterm.lua')
    }
    -- Viewer & finder for LSP symbols and tags
    use {
        'liuchengxu/vista.vim',
        disabled = has_value(g.doom_disabled_plugins, 'vista.vim')
    }
    -- Minimap
    -- Depends on wfxr/code-minimap to work!
    use {
        'wfxr/minimap.vim',
        disabled = has_value(g.doom_disabled_plugins, 'minimap.vim')
    }
    -- Keybindings menu like Emacs's guide-key
    -- cannot be disabled
    use {
        'spinks/vim-leader-guide',
        disabled = false
    }
    -- Distraction free environment
    use {
        'junegunn/goyo.vim',
        disabled = has_value(g.doom_disabled_plugins, 'goyo.vim')
    }

    -----[[--------------]]-----
    ---     Fuzzy Search     ---
    -----]]--------------[[-----
    disabled_fuzzy = has_value(g.doom_disabled_plugins_group, 'fuzzy')
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}
        },
        disable = (disabled_fuzzy and true or has_value(g.doom_disabled_plugins, 'telescope.nvim'))
    }

    -----[[-------------]]-----
    ---     GIT RELATED     ---
    -----]]-------------[[-----
    disabled_git = has_value(g.doom_disabled_plugins_group, 'git')
    -- Git gutter better alternative
    use {
        'mhinz/vim-signify',
        disable = (disabled_git and true or has_value(g.doom_disabled_plugins, 'vim-signify'))
    }
    -- LazyGit integration
    use {
        'kdheepak/lazygit.nvim',
        disable = disabled_git and true or has_value(g.doom_disabled_plugins, 'lazygit.nvim')
    }

    -----[[------------]]-----
    ---     Completion     ---
    -----]]------------[[-----
    disabled_completion = has_value(g.doom_disabled_plugins_group, 'lsp')
    -- Built-in LSP Config
    -- NOTE: It should not be disabled if you are going to use LSP!
    use {
        'neovim/nvim-lspconfig',
        commit = '11a581d1860a7ad2b6c1ee1e0ebbb000e81b9950',
        disable = (disabled_completion and true or has_value(g.doom_disabled_plugins, 'nvim-lspconfig'))
    }
    -- Completion plugin
    -- can be disabled to use your own completion plugin
    use {
        'hrsh7th/nvim-compe',
        requires = {
            {'ray-x/lsp_signature.nvim'}, {'onsails/lspkind-nvim'}, {'norcalli/snippets.nvim'}
        },
        disable = (disabled_completion and true or has_value(g.doom_disabled_plugins, 'nvim-compe'))
    }
    -----[[--------------]]-----
    ---     File Related     ---
    -----]]--------------[[-----
    disabled_files = has_value(g.doom_disabled_plugins_group, 'files')
    -- Write / Read files without permissions (e.g. /etc files) without having to use `sudo nvim /path/to/file`
    use {
        'lambdalisue/suda.vim',
        disable = (disabled_files and true or has_value(g.doom_disabled_plugins, 'suda.vim'))
    }
    -- File formatting
    -- can be disabled to use your own file formatter
    use {
        'sbdchd/neoformat',
        disable = (disabled_files and true or has_value(g.doom_disabled_plugins, 'neoformat'))
    }
    -- Autopairs
    -- can be disabled to use your own autopairs
    use {
        'windwp/nvim-autopairs',
        disable = (disabled_files and true or has_value(g.doom_disabled_plugins, 'nvim-autopairs'))
    }
    -- EditorConfig support
    use {
        'editorconfig/editorconfig-vim',
        disable = (disabled_files and true or has_value(g.doom_disabled_plugins, 'editorconfig-vim'))
    }
    -- Tree-Sitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        disable = (disabled_files and true or has_value(g.doom_disabled_plugins, 'tree-sitter'))
    }
    -- Comments
    -- can be disabled to use your own comments plugin
    use {
        'b3nj5m1n/kommentary',
        disable = (disabled_files and true or has_value(g.doom_disabled_plugins, 'kommentary'))
    }

    -----[[-------------]]-----
    ---     Web Related     ---
    -----]]-------------[[-----
    disabled_web = has_value(g.doom_disabled_plugins_group, 'web')
    -- Fastest colorizer without external dependencies!
    use {
        'norcalli/nvim-colorizer.lua',
        disable = (disabled_web and true or has_value(g.doom_disabled_plugins, 'nvim-colorizer'))
    }
    -- HTPP Client support
    -- Depends on bayne/dot-http to work!
    use {
        'bayne/vim-dot-http',
        disable = (disabled_web and true or has_value(g.doom_disabled_plugins, 'vim-dot-http'))
    }
    -- Emmet plugin
    use {
        'mattn/emmet-vim',
        disable = (disabled_web and true or has_value(g.doom_disabled_plugins, 'emmet-vim'))
    }
end)
