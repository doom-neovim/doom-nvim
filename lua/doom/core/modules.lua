--   doom.core.modules
--
--   Finds and returns user's `modules.lua` file.  Returned result is cached
--   due to lua's `require` caching.
--
--   Later on it executes all of the enabled modules, loading their packer dependencies, autocmds and cmds.

local profiler = require("doom.services.profiler")
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
  if doom.impatient_enabled then
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

local keymaps_service = require("doom.services.keymaps")
local commands_service = require("doom.services.commands")
local autocmds_service = require("doom.services.autocommands")

--- Applies commands, autocommands, packages from enabled modules (`modules.lua`).
modules.load_modules = function()
  local use = require("packer").use
  local logger = require("doom.utils.logging")
  -- Handle the Modules
  for section_name, _ in pairs(doom.modules) do
    for module_name, module in pairs(doom.modules[section_name]) do
      local profile_msg = ("modules|init `%s.%s`"):format(section_name, module_name)
      profiler.start(profile_msg)

      -- Flag to continue enabling module
      local should_enable_module = true

      -- Check module has necessary dependencies
      if module.requires_modules then
        for _, dependent_module in ipairs(module.requires_modules) do
          local dep_section_name, dep_module_name = unpack(vim.split(dependent_module, "%."))

          if not doom.modules[dep_section_name][dep_module_name] then
            should_enable_module = false
            logger.error(
              ('Doom module "%s.%s" depends on a module that is not enabled "%s.%s".  Please enable the %s module.'):format(
                section_name,
                module_name,
                dep_section_name,
                dep_module_name,
                dep_module_name
              )
            )
          end
        end
      end

      if should_enable_module then
        -- Import dependencies with packer from module.packages
        if module.packages then
          for dependency_name, packer_spec in pairs(module.packages) do
            -- Set packer_spec to configure function
            if module.configs and module.configs[dependency_name] then
              packer_spec.config = module.configs[dependency_name]
            end

            local spec = vim.deepcopy(packer_spec)

            -- Set/unset frozen packer dependencies
            if type(spec.commit) == "table" then
              -- Commit can be a table of values, where the keys indicate
              -- which neovim version is required.
              spec.commit = utils.pick_compatible_field(spec.commit)
            end

            if not doom.freeze_dependencies then
              spec.commit = nil
            end

            -- Initialise packer
            use(spec)
          end
        end

        -- Setup package autogroups
        if module.autocmds then
          local autocmds = type(module.autocmds) == "function" and module.autocmds()
            or module.autocmds
          for _, autocmd_spec in ipairs(autocmds) do
            autocmds_service.set(autocmd_spec[1], autocmd_spec[2], autocmd_spec[3], autocmd_spec)
          end
        end

        if module.cmds then
          for _, cmd_spec in ipairs(module.cmds) do
            commands_service.set(cmd_spec[1], cmd_spec[2], cmd_spec[3] or cmd_spec.opts)
          end
        end

        if module.binds then
          keymaps_service.applyKeymaps(
            type(module.binds) == "function" and module.binds() or module.binds
          )
        end
      end
      profiler.stop(profile_msg)
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
    commands_service.set(cmd_spec[1], cmd_spec[2], cmd_spec[3] or cmd_spec.opts)
  end

  -- Handle extra user autocmds
  for _, autocmd_spec in pairs(doom.autocmds) do
    autocmds_service.set(autocmd_spec[1], autocmd_spec[2], autocmd_spec[3], autocmd_spec)
  end

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
