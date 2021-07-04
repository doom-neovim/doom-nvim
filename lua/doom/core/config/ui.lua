---[[---------------------------------------]]---
--       ui.lua - Doom Nvim UI settings        --
--             Author: NTBBloodbath            --
--             License: MIT                    --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')
local config = require('doom.core.config').load_config()

log.debug('Loading Doom UI module ...')

-- If no colorscheme was established then fallback to defauls
if not utils.is_empty(config.doom.colorscheme) then
	local loaded_colorscheme = pcall(function()
		vim.opt.background = config.doom.colorscheme_bg
		vim.api.nvim_command('colorscheme ' .. config.doom.colorscheme)
	end)

	if not loaded_colorscheme then
		log.error('Colorscheme not found, falling to doom-one')
		vim.api.nvim_command('colorscheme ' .. config.doom.colorscheme)
	end
else
	log.warn('Forced default Doom colorscheme')
	vim.api.nvim_command('colorscheme doom-one')
end

-- Set colors based on environment (GUI, TUI)
if config.doom.enable_guicolors then
	if vim.fn.exists('+termguicolors') == 1 then
		vim.opt.termguicolors = true
	elseif vim.fn.exists('+guicolors') == 1 then
		vim.opt.guicolors = true
	end
end
