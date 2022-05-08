--[[
--  doom.core
--
--  Entrypoint for the doom-nvim framework.
--
--]]
--- Main Doom configuration file
--- This file loads all doom core components
--- (ui, options, doomrc, etc)

local utils = require("doom.utils")

-- Sets the `doom` global object
require("doom.core.doom_global")

-- Boostraps the doom-nvim framework, runs the user's `config.lua` file.
local config = utils.safe_require("doom.core.config")
config.load()

-- Load the colourscheme
utils.safe_require("doom.core.ui")

-- Set some extra commands
utils.safe_require("doom.core.commands")


-- Load Doom modules.
local modules = utils.safe_require("doom.core.modules")
modules.start()
modules.load_modules()
modules.handle_user_config()

-- vim: fdm=marker
