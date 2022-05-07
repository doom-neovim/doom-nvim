
--   doom.core.modules
--
--   Finds and returns user's `modules.lua` file.  Returned result is cached
--   due to lua's `require` caching.
--
--   Later on it executes all of the enabled modules, loading their packer dependencies, autocmds and cmds.

local utils = require("doom.utils")
local filename = "modules.lua"

local modules = {}

-- Path cases:
--   1. stdpath('config')/../doom-nvim/modules.lua
--   2. stdpath('config')/modules.lua
--   3. <runtimepath>/doom-nvim/modules.lua
modules.source = utils.find_config(filename)
modules.enabled_modules = dofile(modules.source)

local log = require("doom.utils.logging")
local system = require("doom.core.system")

--- Initial bootstrapping of packer including auto-installation if necessary
modules.start = function()
  -- Packer Bootstrapping
  local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    vim.notify("Bootstrapping packer.nvim, please wait ...")
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    })
    -- Load packer.nvim on first doom launch
    vim.cmd("packadd packer.nvim")
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
      open_fn = doom.use_floating_win_packer and function()
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
end

--- Applies commands, autocommands, packages from enabled modules (`modules.lua`).
modules.load_modules = function()
  local use = require("packer").use
  -- Handle the Modules
  for _, section_name in ipairs({"core", "modules", "user", "langs",}) do
    for module_name, module in pairs(doom[section_name]) do
      -- Import dependencies with packer from module.packages
      if module.packages then
        for dependency_name, packer_spec in pairs(module.packages) do
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
    end
  end
end

--- Applies user's commands, autocommands, packages from `use_*` helper functions.
modules.handle_user_config = function()
  local use = require("packer").use

  -- Handle extra user modules
  for _, packer_spec in ipairs(doom.packages) do
    use(packer_spec)
  end

  -- Handle extra user cmds
  for _, cmd_spec in pairs(doom.cmds) do
    utils.make_cmd(cmd_spec[1], cmd_spec[2])
  end

  -- Handle extra user autocmds
  local autocmds = {}
  for _, cmd_spec in pairs(doom.autocmds) do
    table.insert(autocmds, cmd_spec)
  end
  utils.make_augroup('user', autocmds)

  -- User keybinds handled in `nest` module
end

return modules
