-- doomrc - Doom nvim configurations file
--
-- The doomrc controls what Doom nvim plugins modules are enabled and what
-- features are being used.
--
-- Comment out a plugin to enable it and comment a non-commented one to
-- disable and uninstall it.
--
-- NOTE: you can open the Doom nvim documentation by pressing `SPC d h`. You
-- will find a table of content where you will see a "Doomrc" section under the
-- "Configuration" one. In that section you will find a comprehensive list of
-- the available modules and all their supported flags.

local doom = {
	ui = {
		'dashboard',   -- Start screen
		'doom-themes', -- Additional doom emacs' colorschemes
		'statusline',  -- Statusline
		'tabline',     -- Tabline, shows your buffers list at top
		-- 'zen',      -- Distraction free environment
		'which-key',   -- Keybindings popup menu like Emacs' guide-key
		'indentlines', -- Show indent lines
	},
	doom = {
		-- 'neorg', -- Life Organization Tool
	},
	editor = {
		'auto-session',    -- A small automated session manager for Neovim
		'terminal',        -- Terminal for Neovim
		'explorer',        -- Tree explorer
		'symbols',         -- LSP symbols and tags
		-- 'minimap',      -- Code minimap, requires github.com/wfxr/code-minimap
		'gitsigns',        -- Git signs
		'telescope',       -- Highly extendable fuzzy finder over lists
		-- 'restclient',   -- A fast Neovim http client
		'formatter',       -- File formatting
		'autopairs',       -- Autopairs
		-- 'editorconfig', -- EditorConfig support for Neovim
		'kommentary',      -- Comments plugin
	    'lsp',             -- Language Server Protocols
		'treesitter',      -- An incremental parsing system for programming tools
		'snippets',        -- LSP snippets
	},
	langs = {
		-- TODO: add more languages here
		-- To enable LSP for a language just add the +lsp flag at the end
		-- e.g. 'rust +lsp'
		--
		-- 'javascript',  -- JavaScript support
		-- 'typescript',  -- TypeScript support
		-- 'python +lsp', -- Python support + lsp
		'lua',            -- Support for our gods language
		-- 'rust +lsp',   -- Let's get rusty!
		-- 'config',      -- Configuration files (JSON, YAML, TOML)
	},
	utilities = {
		-- 'suda',            -- Write and read files without sudo permissions
		-- 'lazygit',         -- LazyGit integration for Neovim, requires LazyGit
		-- 'neogit',          -- Magit for Neovim
		-- 'octo',            -- GitHub in Neovim, requires GitHub CLI
		-- 'colorizer',       -- Fastets colorizer for Neovim
		'range-highlight',    -- hightlights ranges you have entered in commandline
	},
}

return doom
