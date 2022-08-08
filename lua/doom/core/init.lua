--[[
--  doom.core
--
--  Entrypoint for the doom-nvim framework.
--
--]]

-- Disable vim builtins for faster startup time
local g = vim.g

g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1

g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1

g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1

-- Sets the `doom` global object
require("doom.core.doom_global")

local utils = require("doom.utils")

-- Boostraps the doom-nvim framework, runs the user's `config.lua` file.
local config = utils.safe_require("doom.core.config")
config.load()
if not utils.is_module_enabled("features", "netrw") then
  g.loaded_netrw = 1
  g.loaded_netrwPlugin = 1
  g.loaded_netrwSettings = 1
  g.loaded_netrwFileHandlers = 1
end

-- Load the colourscheme
utils.safe_require("doom.core.ui")

-- Set some extra commands
utils.safe_require("doom.core.commands")

-- Load Doom modules.
local modules = utils.safe_require("doom.core.modules")
modules.start()
modules.load_modules()
modules.handle_user_config()
modules.try_sync()

-- Execute autocommand for user to hook custom config into
vim.api.nvim_exec_autocmds("User", {
  pattern = "DoomStarted",
})

-- vim: fdm=marker
