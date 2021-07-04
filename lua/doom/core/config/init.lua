---[[---------------------------------------]]---
--          config - Core of Doom Nvim         --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local M = {}

local log = require('doom.core.logging')
local utils = require('doom.utils')

log.debug('Loading Doom core config module ...')

-- Check if running Neovim or Vim and fails if:
--  1. Running Vim instead of Neovim
--  2. Running Neovim 0.4 or below
if vim.fn.has('nvim') == 1 then
	if vim.fn.has('nvim-0.5') ~= 1 then
		log.fatal('Doom Nvim requires Neovim 0.5.0')
	end
else
	log.fatal(
		'Doom Nvim does not have support for Vim, please use it with Neovim instead'
	)
end

-- Set some configs on load
if vim.fn.has('vim_starting') then
	-- Set encoding
	vim.opt.encoding = 'utf-8'
	-- Required to use some colorschemes and improve colors
	vim.opt.termguicolors = true
end

-- load_config Loads the doom_config.lua file if it exists
-- @return table
M.load_config = function()
	local config = {
		doom = {},
		nvim = {},
	}

	-- /home/user/.config/doom-nvim/doomrc
	if vim.fn.filereadable(utils.doom_root .. '/doom_config.lua') == 1 then
		local loaded_doomrc, err = pcall(function()
			log.debug('Loading the doom_config file ...')
			config = dofile(utils.doom_root .. '/doom_config.lua')
		end)

		if not loaded_doomrc then
			log.error(
				'Error while loading the doom_config file. Traceback:\n' .. err
			)
		end
	else
		log.warn('No doom_config.lua file found')
	end

	return config
end

-- Check plugins updates on start if enabled
if M.load_config().doom.check_updates then
	require('doom.core.functions').check_updates()
end

return M
