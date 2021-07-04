---[[---------------------------------------]]---
--     doomrc.lua - Load Doom Nvim doomrc      --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')

local M = {}

log.debug('Loading Doom doomrc module ...')

-- default_doomrc_values loads the default doomrc values
-- @return table
local function default_doomrc_values()
	return {
		doom = {
			ui = {
				'dashboard', -- Start screen
				'doom-themes', -- Additional doom emacs' colorschemes
				'statusline', -- Statusline
				'tabline', -- Tabline, shows your buffers list at top
				-- 'zen',      -- Distraction free environment
				'which-key', -- Keybindings popup menu like Emacs' guide-key
				'indentlines', -- Show indent lines
			},
			doom = {
				-- 'neorg', -- Life Organization Tool
			},
			editor = {
				'auto-session', -- A small automated session manager for Neovim
				'terminal', -- Terminal for Neovim
				'explorer', -- Tree explorer
				'symbols', -- LSP symbols and tags
				-- 'minimap',      -- Code minimap, requires github.com/wfxr/code-minimap
				-- 'gitsigns',     -- Git signs
				'telescope', -- Highly extendable fuzzy finder over lists
				-- 'restclient',   -- A fast Neovim http client
				'formatter', -- File formatting
				'autopairs', -- Autopairs
				-- 'editorconfig', -- EditorConfig support for Neovim
				'kommentary', -- Comments plugin
				'lsp', -- Language Server Protocols
				'treesitter', -- An incremental parsing system for programming tools
				'snippets', -- LSP snippets
			},
			langs = {
				-- 'javascript',  -- JavaScript support
				-- 'typescript',  -- TypeScript support
				-- 'python +lsp', -- Python support + lsp
				'lua', -- Support for our gods language
				-- 'rust +lsp',   -- Let's get rusty!
				-- 'config',      -- Configuration files (JSON, YAML, TOML)
			},
			utilities = {
				-- 'suda',      -- Write and read files without sudo permissions
				-- 'lazygit',   -- LazyGit integration for Neovim, requires LazyGit
				-- 'neogit',    -- Magit for Neovim
				-- 'octo',      -- GitHub in Neovim, requires GitHub CLI
				-- 'colorizer', -- Fastets colorizer for Neovim
			},
		},
	}
end

-- load_doomrc Loads the doomrc if it exists, otherwise it'll fallback to doom
-- default configs.
M.load_doomrc = function()
	local config

	-- /home/user/.config/doom-nvim/doomrc
	if vim.fn.filereadable(utils.doom_root .. '/doomrc.lua') == 1 then
		local loaded_doomrc, err = pcall(function()
			log.debug('Loading the doomrc file ...')
			config = dofile(utils.doom_root .. '/doomrc.lua')
		end)

		if not loaded_doomrc then
			log.error('Error while loading the doomrc. Traceback:\n' .. err)
		end
	else
		log.warn('No doomrc.lua file found, falling to defaults')
		config = default_doomrc_values()
	end

	return config
end

return M
