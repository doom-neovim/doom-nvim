----- Plugins modules
-- Essentials         / (Plugin manager, vimpeccable, treesitter, sessions)
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

--- Disabled modules
local disabled_git = Has_value(Doom.disabled_modules, 'git')
local disabled_lsp = Has_value(Doom.disabled_modules, 'lsp')
local disabled_files = Has_value(Doom.disabled_modules, 'files')
local disabled_web = Has_value(Doom.disabled_modules, 'web')

local packer = require('packer')
return packer.startup(function()
	-----[[------------]]-----
	---     Essentials     ---
	-----]]------------[[-----
	-- Plugins manager, remove the branch field when that branch is merged
	-- in the main branch.
	use({
		'wbthomason/packer.nvim',
		branch = 'fix/premature-display-opening',
	})

	-- Auxiliar functions for using Lua in Neovim
	use('svermeulen/vimpeccable')

	-- Tree-Sitter
	local disabled_treesitter =
		Has_value(Doom.disabled_plugins, 'treesitter')
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		disable = (disabled_files and true or disabled_treesitter),
	})

	-- Sessions
	use({
		'rmagatti/auto-session',
		requires = { 'rmagatti/session-lens' },
	})

	-----[[------------]]-----
	---     UI Related     ---
	-----]]------------[[-----
	-- Fancy start screen
	-- cannot be disabled
	use({ 'glepnir/dashboard-nvim', disable = false })

	-- Colorschemes
	local disabled_colorschemes =
		Has_value(Doom.disabled_plugins, 'colorschemes')
	if disabled_colorschemes then
		table.insert(disabled_plugins, 'colorschemes')
	end
	use({
		'GustavoPrietoP/doom-themes.nvim',
		disable = disabled_theme,
	})
    
	-- File tree
	local disabled_tree = Has_value(Doom.disabled_plugins, 'tree')
	use({
		'kyazdani42/nvim-tree.lua',
		requires = { 'kyazdani42/nvim-web-devicons' },
		disable = disabled_tree,
	})

	-- Statusline
	-- can be disabled to use your own statusline
	local disabled_statusline =
		Has_value(Doom.disabled_plugins, 'statusline')
	use({
		'glepnir/galaxyline.nvim',
		disable = disabled_statusline,
	})

	-- Tabline
	-- can be disabled to use your own tabline
	local disabled_tabline = Has_value(Doom.disabled_plugins, 'tabline')
	use({ 'romgrk/barbar.nvim', disable = disabled_tabline })

	-- Better terminal
	-- can be disabled to use your own terminal plugin
	local disabled_terminal = Has_value(Doom.disabled_plugins, 'terminal')
	use({
		'akinsho/nvim-toggleterm.lua',
		disable = disabled_terminal,
	})

	-- Viewer & finder for LSP symbols and tags
	local disabled_outline = Has_value(Doom.disabled_plugins, 'outline')
	use({
		'simrat39/symbols-outline.nvim',
		disable = disabled_outline,
	})

	-- Minimap
	-- Depends on wfxr/code-minimap to work!
	local disabled_minimap = Has_value(Doom.disabled_plugins, 'minimap')
	use({ 'wfxr/minimap.vim', disable = disabled_minimap })

	-- Keybindings menu like Emacs's guide-key
	-- cannot be disabled
	use({ 'folke/which-key.nvim', disable = false })

	-- Distraction free environment
	local disabled_zen = Has_value(Doom.disabled_plugins, 'zen')
	use({ 'kdav5758/TrueZen.nvim', disable = disabled_zen })

	-----[[--------------]]-----
	---     Fuzzy Search     ---
	-----]]--------------[[-----
	use({
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
		disable = false,
	})

	-----[[-------------]]-----
	---     GIT RELATED     ---
	-----]]-------------[[-----
	-- Git gutter better alternative, written in Lua
	-- can be disabled to use your own git gutter plugin
	local disabled_gitsigns = Has_value(Doom.disabled_plugins, 'gitsigns')
	use({
		'lewis6991/gitsigns.nvim',
		disable = (disabled_git and true or disabled_gitsigns),
	})

	-- LazyGit integration
	local disabled_lazygit = Has_value(Doom.disabled_plugins, 'lazygit')
	use({
		'kdheepak/lazygit.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		disable = (disabled_git and true or disabled_lazygit),
	})

	-----[[------------]]-----
	---     Completion     ---
	-----]]------------[[-----
	-- Built-in LSP Config
	-- NOTE: It should not be disabled if you are going to use LSP!
	local disabled_lspconfig = Has_value(Doom.disabled_plugins, 'lspconfig')
	use({
		'neovim/nvim-lspconfig',
		disable = (disabled_lsp and true or disabled_lspconfig),
	})
	-- Completion plugin
	-- can be disabled to use your own completion plugin
	local disabled_compe = Has_value(Doom.disabled_plugins, 'compe')
	use({
		'hrsh7th/nvim-compe',
		requires = {
			{ 'ray-x/lsp_signature.nvim' },
			{ 'onsails/lspkind-nvim' },
			{ 'norcalli/snippets.nvim' },
		},
		disable = (disabled_lsp and true or disabled_compe),
	})

	-- install lsp saga
	local disabled_lspsaga = Has_value(Doom.disabled_plugins, 'lspsaga')
	use({
		'glepnir/lspsaga.nvim',
		disable = (disabled_lsp and true or disabled_lspsaga),
	})

	-- provides the missing `:LspInstall` for `nvim-lspconfig`.
	local disabled_lspinstall =
		Has_value(Doom.disabled_plugins, 'lspinstall')
	use({
		'kabouzeid/nvim-lspinstall',
		disable = (disabled_lsp and true or disabled_lspinstall),
	})

	-----[[--------------]]-----
	---     File Related     ---
	-----]]--------------[[-----
	-- Write / Read files without permissions (e.G. /etc files) without having
	-- to use `sudo nvim /path/to/file`
	local disabled_suda = Has_value(Doom.disabled_plugins, 'suda')
	use({
		'lambdalisue/suda.vim',
		disable = (disabled_files and true or disabled_suda),
	})

	-- File formatting
	-- can be disabled to use your own file formatter
	local disabled_formatter = Has_value(Doom.disabled_plugins, 'formatter')
	use({
		'lukas-reineke/format.nvim',
		disable = (disabled_files and true or disabled_formatter),
	})

	-- Autopairs
	-- can be disabled to use your own autopairs
	local disabled_autopairs = Has_value(Doom.disabled_plugins, 'autopairs')
	use({
		'steelsojka/pears.nvim',
		disable = (disabled_files and true or disabled_autopairs),
	})

	-- Indent Lines
	local disabled_indent_lines =
		Has_value(Doom.disabled_plugins, 'indentlines')
	use({
		'lukas-reineke/indent-blankline.nvim',
		branch = 'lua',
		disable = (disabled_files and true or disabled_indent_lines),
	})

	-- EditorConfig support
	local disabled_editorconfig =
		Has_value(Doom.disabled_plugins, 'editorconfig')
	use({
		'editorconfig/editorconfig-vim',
		disable = (disabled_files and true or disabled_editorconfig),
	})

	-- Comments
	-- can be disabled to use your own comments plugin
	local disabled_kommentary =
		Has_value(Doom.disabled_plugins, 'kommentary')
	use({
		'b3nj5m1n/kommentary',
		disable = (disabled_files and true or disabled_kommentary),
	})

	-----[[-------------]]-----
	---     Web Related     ---
	-----]]-------------[[-----
	-- Fastest colorizer without external dependencies!
	local disabled_colorizer = Has_value(Doom.disabled_plugins, 'colorizer')
	use({
		'norcalli/nvim-colorizer.lua',
		disable = (disabled_web and true or disabled_colorizer),
	})

	-- HTTP Client support
	-- Depends on bayne/dot-http to work!
	local disabled_restclient =
		Has_value(Doom.disabled_plugins, 'restclient')
	use({
		'bayne/vim-dot-http',
		disable = (disabled_web and true or disabled_restclient),
	})

	-- Emmet plugin
	local disabled_emmet = Has_value(Doom.disabled_plugins, 'emmet')
	use({
		'mattn/emmet-vim',
		disable = (disabled_web and true or disabled_emmet),
	})

	-----[[----------------]]-----
	---     Custom Plugins     ---
	-----]]----------------[[-----
	-- If there are custom plugins then also require them
	for _, plug in pairs(Doom.custom_plugins) do
		Custom_plugins(plug)
	end
end)
