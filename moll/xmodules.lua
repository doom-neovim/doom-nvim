--- Applies commands, autocommands, packages from enabled modules (`modules.lua`).
modules.load_modules = function()
  local use = require("packer").use

  for _, module in ipairs(utils.get_all_modules()) do
    if module.enabled then

      if module.packages then
        for dependency_name, packer_spec in pairs(module.packages) do

          -- Set packer_spec to configure function
          if module.configs and module.configs[dependency_name] then
            packer_spec.config = module.configs[dependency_name]
          end

          packer_spec.commit = doom.settings.freeze_dependencies and packer_spec.commit or nil

          use(packer_spec)
        end
      end

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
    end
  end
end
