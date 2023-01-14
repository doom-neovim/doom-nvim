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

local keymaps_service = require("doom.services.keymaps")
local commands_service = require("doom.services.commands")
local autocmds_service = require("doom.services.autocommands")

--- Applies commands, autocommands, packages from enabled modules (`modules.lua`).
modules.load_modules = function()
  local logger = require("doom.utils.logging")
  -- Handle the Modules
  for section_name, _ in pairs(doom.modules) do
    for module_name, module in pairs(doom.modules[section_name]) do
      if type(module) ~= "table" then
        print(("Error on module %s type is %s val is %s"):format(module_name, type(module), module))
      end
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

            -- Only pin dependencies if doom.freeze_dependencies is true
            spec.lock = spec.commit and doom.freeze_dependencies

            -- Save module spec to be initialised later
            table.insert(doom.packages, spec)
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
  end
end

modules.handle_lazynvim = function()
  require("lazy").setup(doom.packages)
end

return modules
