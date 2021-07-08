---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: GPLv2                    --
---[[---------------------------------------]]---

-- Utility functions
require('doom.utils')

-- Load default settings
require('doom.default')

-- Logging
require('doom.logging')

-- Load configurations
require('doom.config.doomrc')

-- Core modules
require('doom.system')
require('doom.functions')
require('doom.config.doomrc')

-- Main configurations
require('doom.config')
require('doom.config.ui')
require('doom.autocmds')
require('doom.keybindings')
