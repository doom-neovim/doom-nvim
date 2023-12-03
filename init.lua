
-- PATCH: in order to address the message:
-- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
--   This feature will be removed in Nvim version 0.10
-- PATCH: in order to address the message:
-- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
--   This feature will be removed in Nvim version 0.10
local orig_notify = vim.notify
local filter_notify = function(text, level, opts)
  -- more specific to this case
  if type(text) == "string" and (string.find(text, "get_query", 1, true) or string.find(text, "get_node_text", 1, true)) then
  -- for all deprecated and stack trace warnings
  -- if type(text) == "string" and (string.find(text, ":help deprecated", 1, true) or string.find(text, "stack trace", 1, true)) then
    return
  end
  orig_notify(text, level, opts)
end
vim.notify = filter_notify

-- Check if user is running Doom in a supported Neovim version before trying to load anything
if vim.fn.has("nvim-0.7.0") ~= 1 then
  local message = table.concat({
    "You are using an unsupported version of Neovim.",
    "",
    "Doom nvim and many of its plugins require at least version 0.7.0 to work as expected.",
    "Consider updating if you run into issues.",
    "https://github.com/doom-neovim/doom-nvim/blob/main/docs/updating-neovim.md",
  }, "\n")
  vim.notify(message, vim.log.levels.ERROR)
end

local profiler = require("doom.services.profiler")
profiler.start("framework|init.lua")

-- Preload lazy nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Bootstrapping lazy.nvim, please wait...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Makes sure ~/.local/share/nvim exists, to prevent problems with logging
vim.fn.mkdir(vim.fn.stdpath("data"), "p")

-- Add ~/.local/share to runtimepath early, such that
-- neovim autoloads plugin/packer_compiled.lua along with vimscript,
-- before we start using the plugins it lazy-loads.
vim.opt.runtimepath:append(vim.fn.stdpath("data"))

-- Load the doom-nvim framework
require("doom.core")

vim.defer_fn(function()
  -- Check for updates
  if doom.check_updates and doom.core.updater then
    doom.core.updater.check_updates(true)
  end
end, 1)


profiler.stop("framework|init.lua")
