---[[---------------------------------------]]---
--          config - Core of Doom Nvim         --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---
-- Doom Nvim version
Doom_version = '2.3.5'

-- Check if running Neovim or Vim and fails if:
--  1. Running Vim instead of Neovim
--  2. Running Neovim 0.4 or below
if Fn.has('nvim') then
	if Fn.has('nvim-0.5') ~= 1 then
		Log_message('!!!', 'Doom Nvim requires Neovim 0.5.0', 2)
	end
else
	Log_message(
		'!!!',
		'Doom Nvim does not have support for Vim, please use it with Neovim instead',
		2
	)
end

-- Set some configs on load
if Fn.has('vim_starting') then
	-- Set encoding
	Opt('o', 'encoding', 'utf-8')
	-- Required to use some colorschemes and improve colors
	Opt('o', 'termguicolors', true)
end

----- Start Doom and run packer.nvim
-- Search for a configuration file (doomrc)
Check_BFC()
if Doom_bfc then
	Load_BFC()
end
-- Set which separator should be used for paths
Which_os()
-- Load the default Neovim settings, e.g. tabs width
Default_options()

-- Load packer.nvim and load plugins settings
require('plugins')
require('doom.config.load_plugins')

-- Load the user-defined settings (global variables, autocmds, mappings)
Custom_commands()

if Doom.check_updates then
	Check_updates()
end
