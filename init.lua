---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: MIT                    --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------
-- Utility functions
require('doom.utils')
-- Load default settings
require('doom.default')
-- Logging system
require('doom.logging')
-- Doom system detection
require('doom.system')
-- Doom functions
require('doom.functions')

---- Doom Configurations ------------------------
-------------------------------------------------
-- Load doomrc (user-defined configurations)
require('doom.config.doomrc')
-- Load main configurations
require('doom.config')
-- UI settings
require('doom.config.ui')
-- Doom autocommands
require('doom.autocmds')
-- Doom keybindings
require('doom.keybindings')
