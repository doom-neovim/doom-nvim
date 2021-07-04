--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, modules, packer, ect)

-- Doom core configurations
require('doom.core.config')
require('doom.core.config.ui')
-- Neovim configurations, e.g. shiftwidth
require('doom.core.default').load_default_options()
-- User-defined settings (global variables, mappings, ect)
require('doom.core.default').custom_options()
-- Doom modules (packer and plugins)
require('doom.modules')
-- Doom keybindings
require('doom.core.keybindings')
-- Doom autocommands
require('doom.core.autocmds')

-- Automatically install language servers
require('doom.core.config').install_servers(require('doom.core.config.doomrc').load_doomrc().langs)
