---[[---------------------------------------]]---
--          config - Core of Doom Nvim         --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

log.debug('Loading Doom core config module ...')
-- Doom Nvim version
Doom_version = '2.3.2'

-- Check if running Neovim or Vim and fails if:
--  1. Running Vim instead of Neovim
--  2. Running Neovim 0.4 or below
if vim.fn.has('nvim') then
	if vim.fn.has('nvim-0.5') ~= 1 then
		log.fatal('Doom Nvim requires Neovim 0.5.0')
	end
else
	log.fatal('Doom Nvim does not have support for Vim, please use it with Neovim instead')
end

-- Set some configs on load
if vim.fn.has('vim_starting') then
	-- Set encoding
	vim.opt.encoding = 'utf-8'
	-- Required to use some colorschemes and improve colors
	vim.opt.termguicolors = true
end

----- Start Doom and run packer.nvim
-- Search for a configuration file (doomrc)
local doomrc_exists = Check_BFC()
if doomrc_exists then
	Load_BFC()
end

-- Set which separator should be used for paths, unused at the moment
-- Which_os()

-- Load the default Neovim settings, e.g. tabs width
Default_options()

-- Load packer.nvim and load plugins settings
require('doom.modules')

-- Load the user-defined settings (global variables, autocmds, mappings)
Custom_options()

if Doom.check_updates then
	Check_updates()
end
