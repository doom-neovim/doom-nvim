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
			-- Autosave
			-- false : Disable autosave
			-- true  : Enable autosave
			-- @default = false
			autosave = false,

			-- Format on save
			-- false : Disable format on save
			-- true  : Enable format on save
			-- @default = false
			fmt_on_save = false,

			-- Autosave sessions
			-- false : Disable session autosave
			-- true  : Enable session autosave
			-- @default = false
			autosave_sessions = false,

			-- Autoload sessions
			-- false : Disable session autoload
			-- true  : Enable session autosave
			-- @default = false
			autoload_last_session = false,

			-- Preserve last editing position
			-- false : Disable preservation of last editing position
			-- true  : Enable preservation of last editing position
			-- @default = false
			preserve_edit_pos = false,

			-- Default indent size
			-- @default = 4
			indent = 4,

			-- Show indent lines
			-- @default = true
			show_indent = true,

			-- Expand tabs
			-- Specifies if spaces or tabs must be used
			-- false : spaces
			-- true  : tabs
			-- @default = true
			expand_tabs = true,

			-- Set numbering
			-- false : Shows absolute number lines
			-- true  : Shows relative number lines
			-- @default = true
			relative_num = true,

			-- Set max cols
			-- Defines the column to show a vertical marker
			-- @default = 80
			max_columns = 80,

			-- Enable guicolors
			-- Enables gui colors on GUI versions of Neovim
			-- @default = true
			enable_guicolors = true,

			-- Sidebar sizing
			-- Specifies the default width of Tree Explorer and Symbols-Outline
			-- @default = 25
			sidebar_width = 25,

			-- Symbols-Outline left
			-- Sets Symbols-Outline buffer to the left when enabled
			-- @default = true
			symbols_outline_left = true,

			-- Show hidden files
			-- @default = true
			show_hidden = true,

			-- Default colorscheme
			-- @default = doom-one
			colorscheme = 'doom-one',

			-- Background color
			-- @default = dark
			colorscheme_bg = 'dark',

			-- Check updates on start
			-- @default = false
			check_updates = false,

			-- Set the Terminal direction
			-- Available directions:
			--   - vertical
			--   - horizontal
			--   - window
			--   - float
			-- @default = 'horizontal'
			terminal_direction = 'horizontal',

			-- Set the Terminal width
			-- Applies only to float direction
			-- @default = 70
			terminal_width = 70,

			-- Set the Terminal height
			-- Applies to all directions except window
			-- @default = 20
			terminal_height = 20,

			-- Conceal level
			-- Set Neovim conceal level
			-- 0 : Disable indentline and show all
			-- 1 : Conceal some functions and show indentlines
			-- 2 : Concealed text is completely hidden unless it has a custom replacement
			--     character defined
			-- 3 : Concealed text is completely hidden
			-- @default = 0
			conceallevel = 0,

			-- Logging level
			-- Set Doom logging level
			-- Available levels:
			--   · trace
			--   · debug
			--   · info
			--   · warn
			--   · error
			--   · fatal
			-- @default = 'info'
			logging = 'info',
		},

		nvim = {
			-- Set custom Neovim global variables
			-- @default = {}
			-- example:
			--   { ['sonokai_style'] = 'andromeda' }
			global_variables = {},

			-- Set custom autocommands
			-- @default = {}
			-- example:
			--   augroup_name = {
			--      { 'BufNewFile,BufRead', 'doomrc', 'set ft=lua'}
			--   }
			autocmds = {},

			-- Set custom key bindings
			-- @default = {}
			-- example:
			--   {
			--      {'n', 'ca', ':Lspsaga code_action<CR>'}
			--   }
			--
			--   where
			--     'n' is the map scope
			--     'ca' is the map activator
			--     ':Lspsaga ...' is the command to be executed
			mappings = {},
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
