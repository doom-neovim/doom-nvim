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

-- Merge core modules (can't be disabled) with user enabled modules
local core_modules = {
  core = {
    "doom",
    "nest",
    "treesitter",
    "reloader",
    "updater",
  },
}
modules.enabled_modules = vim.tbl_deep_extend("keep", core_modules, dofile(modules.source))

local system = require("doom.core.system")

--- Initial bootstrapping of packer including auto-installation if necessary
--- Initial bootstrapping of impatient.nvim
modules.start = function()
  if doom.settings.impatient_enabled then
    local has_impatient = pcall(require, "impatient")
    if not has_impatient then
      -- Packer Bootstrapping
      local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/impatient.nvim"
      if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
        vim.notify("Bootstrapping impatient.nvim, please wait ...")
        vim.fn.system({
          "git",
          "clone",
          "--depth",
          "1",
          "https://github.com/lewis6991/impatient.nvim",
          packer_path,
        })
      end

      vim.cmd("packadd impatient.nvim")

      require("impatient")
    end
  end

  local has_packer = pcall(require, "packer")
  if not has_packer then
    modules._needs_sync = true
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
    end

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
      open_fn = doom.settings.use_floating_win_packer and function()
        return require("packer.util").float({ border = doom.settings.border_style })
      end,
    },
    profile = {
      enable = true,
    },
    log = {
      level = doom.settings.logging,
    },
  })

  packer.reset()
end

local keymaps_service = require("doom.services.keymaps")

--- Applies commands, autocommands, packages from enabled modules (`modules.lua`).
modules.load_modules = function()
  local use = require("packer").use
  -- Handle the Modules
  -- TODO: pass `doom.modules` to recursive function

  -- print(vim.inspect(doom.modules) )

  -- default > traverse `doom.modules` if nothing specified
  require("doom.utils.tree").traverse_table({
    tree = doom.modules,
    filter = "doom_module_single",
    leaf = function(_, module_name, module)
      -- print(module_name, module)

      -- Import dependencies with packer from module.packages
      -- print(module_name, module)
      if module.packages then
        for dependency_name, packer_spec in pairs(module.packages) do
          -- Set packer_spec to configure function
          if module.configs and module.configs[dependency_name] then
            packer_spec.config = module.configs[dependency_name]
          end

          -- Set/unset frozen packer dependencies
          packer_spec.commit = doom.settings.freeze_dependencies and packer_spec.commit or nil

          -- Initialise packer
          use(packer_spec)
        end
      end

      -- Setup package autogroups
      if module.autocmds then
        local autocmds = type(module.autocmds) == "function" and module.autocmds()
          or module.autocmds
        utils.make_augroup(module_name, autocmds)
      end

      if module.cmds then
        for _, cmd_spec in ipairs(module.cmds) do
          utils.make_cmd(cmd_spec[1], cmd_spec[2])
        end
      end

      if module.binds then
        keymaps_service.applyKeymaps(
          type(module.binds) == "function" and module.binds() or module.binds
        )
      end
    end,
  })
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
  utils.make_augroup("user", autocmds)

  -- Handle extra user keybinds
  for _, keybinds in ipairs(doom.binds) do
    keymaps_service.applyKeymaps(keybinds)
  end
end

modules.try_sync = function()
  if modules._needs_sync then
    vim.api.nvim_create_autocmd("User", {
      pattern = "PackerComplete",
      callback = function()
        local logger = require("doom.utils.logging")
        logger.error("Doom-nvim has been installed.  Please restart doom-nvim.")
      end,
    })
    require("packer").sync()
  end
end

return modules
