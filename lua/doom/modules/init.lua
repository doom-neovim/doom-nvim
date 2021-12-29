local utils = require("doom.utils")
local use_floating_win_packer = doom.use_floating_win_packer
local log = require("doom.utils.logging")
local system = require("doom.core.system")
local enabled_modules = require("doom.core.config.modules").modules

-- Packer Bootstrapping
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  log.info("Bootstrapping packer.nvim, please wait ...")
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    packer_path,
  })
end

-- Load packer
vim.cmd([[packadd packer.nvim]])
local packer = require("packer")

-- Change some defaults
-- Of particular interest is compile_path: we use stdpath("data"), so as to not
-- have anything generated in Doom source (which goes in stdpath("config")).
packer.init({
  compile_path = system.doom_compile_path,
  git = {
    clone_timeout = 300, -- 5 mins
    subcommands = {
      -- Prevent packer from downloading all branches metadata to reduce cloning cost
      -- for heavy size plugins like plenary (removed the '--no-single-branch' git flag)
      install = "clone --depth %i --progress",
    },
  },
  display = {
    open_fn = use_floating_win_packer and function()
      return require("packer.util").float({ border = doom.border_style })
    end,
  },
  profile = {
    enable = true,
  },
  log = {
    level = doom.logging,
  },
})

packer.reset()

-- Flatten the multiple packer config tables into one to rule them all.
local packer_config = {}
for _, module in ipairs(enabled_modules) do
  local new_configs = require(("doom.modules.%s"):format(module)).packer_config
  for name, value in pairs(new_configs) do
    packer_config[name] = value
  end
end
-- Iterate packages. These can be added by modules or by the user in
-- `config.lua`. See `load()` in doom/core/config/init.lua
for name, spec in pairs(doom.packages) do
  -- Set empty defaults in case the functions don't exist.
  if type(packer_config[name]) ~= "function" then
    packer_config[name] = function() end
  end
  if type(spec.config) ~= "function" then
    spec.config = function() end
  end
  packer.use(vim.tbl_deep_extend("force", spec, {
    -- First, run the module config (sometimes an empty function, see
    -- above), then the hook passed by the user. This cannot be done with
    -- a function that calls both sequentially, see packer's README on
    -- captures and `string.dump`.
    config = { packer_config[name], spec.config },
  }))
end

-- Register autocmds, which, like packages, can come from modules or the
-- user.
for module, cmds in pairs(doom.autocmds) do
  local augroup_name = ("doom_%s"):format(module)
  utils.create_augroups({
    [augroup_name] = cmds,
  })
end
