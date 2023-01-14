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


local profiler = require("doom.services.profiler")

-- Sets the `doom` global object
profiler.start("framework|doom.core.doom_global")
require("doom.core.doom_global")
profiler.stop("framework|doom.core.doom_global")

profiler.start("framework|doom.utils")
local utils = require("doom.utils")
profiler.stop("framework|doom.utils")

-- Boostraps the doom-nvim framework, runs the user's `config.lua` file.
profiler.start("framework|doom.core.config (setup + user)")
local config = utils.safe_require("doom.core.config")
config.load()
profiler.stop("framework|doom.core.config (setup + user)")
if not utils.is_module_enabled("features", "netrw") then
  g.loaded_netrw = 1
  g.loaded_netrwPlugin = 1
  g.loaded_netrwSettings = 1
  g.loaded_netrwFileHandlers = 1
end

-- Set some extra commands
utils.safe_require("doom.core.commands")

profiler.start("framework|doom.core.modules")
-- Load Doom modules.
local modules = utils.safe_require("doom.core.modules")
profiler.start("framework|init enabled modules")
modules.load_modules()
profiler.stop("framework|init enabled modules")
profiler.start("framework|user settings")
modules.handle_user_config()
profiler.stop("framework|user settings")
modules.try_sync()
modules.handle_lazynvim()
profiler.stop("framework|doom.core.modules")

-- Load the colourscheme
profiler.start("framework|doom.core.ui")
utils.safe_require("doom.core.ui")
profiler.stop("framework|doom.core.ui")

-- Execute autocommand for user to hook custom config into
vim.api.nvim_exec_autocmds("User", {
  pattern = "DoomStarted",
})

-- vim: fdm=marker
