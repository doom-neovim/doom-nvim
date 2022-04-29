--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, etc)

local utils = require("doom.utils")

-- Required setup modules.
local core_modules = { "commands", "ui" }
utils.load_modules("doom.core", core_modules)
