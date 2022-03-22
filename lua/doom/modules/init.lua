local utils = require("doom.utils")
local use_floating_win_packer = doom.use_floating_win_packer
local log = require("doom.utils.logging")
local system = require("doom.core.system")
local enabled_modules = require("doom.core.config.modules").modules

-- Packer Bootstrapping
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  log.info("Bootstrapping packer.nvim, please wait ...")
  vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    packer_path,
  })
end

-- Load packer
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

local use = packer.use
packer.reset()

-- Handle the Modules
for module_name, module in pairs(doom.modules) do
  -- Setup package autogroups
  if module.autocmds then
    local autocmds = type(module.autocmds) == 'function' and module.autocmds() or module.autocmds
    utils.make_augroup(module_name, autocmds)
  end

  if module.cmds then
    for _, cmd_spec in ipairs(module.cmds) do
      utils.make_cmd(cmd_spec[1], cmd_spec[2])
    end
  end
  -- Import dependencies with packer from module.uses
  if module.uses then
    for dependency_name, packer_spec in pairs(module.uses) do
      -- Set packer_spec to configure function
      if module.configs and module.configs[dependency_name] then
        packer_spec.config = module.configs[dependency_name]
      end

      -- Set/unset frozen packer dependencies
      packer_spec.commit = doom.freeze_dependencies and packer_spec.commit or nil

      -- Initialise packer
      use(packer_spec)
    end
  end
end

-- Handle extra user modules
for _, packer_spec in ipairs(doom.uses) do
  use(packer_spec)
end

-- Handle extra user cmds
for _, cmd_spec in pairs(doom.cmds) do
  print(cmd_spec[1])
  utils.make_cmd(cmd_spec[1], cmd_spec[2])
end

-- Handle extra user autocmds
local autocmds = {}
for _, cmd_spec in pairs(doom.autocmds) do
  table.insert(autocmds, cmd_spec)
end
utils.make_augroup('user', autocmds)

-- User keybinds handled in `nest` module
