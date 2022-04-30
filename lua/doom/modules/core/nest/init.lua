local nest = {}

nest.settings = {
}

nest.packages = {
  ["nest.nvim"] = {
    "connorgmeehan/nest.nvim",
    branch = "integrations-api",
    after = "nvim-mapper",
  },
}

nest.configs = {}
nest.configs["nest.nvim"] = function()
  local utils = require("doom.utils")
  local is_module_enabled = utils.is_module_enabled

  local nest_package = require("nest")

  nest_package.enable(require("nest.integrations.mapper"))
  if is_module_enabled("whichkey") then
    local whichkey_integration = require("nest.integrations.whichkey")
    nest_package.enable(whichkey_integration)
  end

  local last_module = '';
  local ok, err = xpcall(function()
    for _, section_name in ipairs({"user", "modules", "langs"}) do
      for module_name, module in pairs(doom[section_name]) do
        last_module = module_name
        if module.binds then
          nest_package.applyKeymaps(type(module.binds) == 'function' and module.binds() or module.binds)
        end
      end
    end
    -- Apply user keybinds
    last_module = 'user provided keybinds  (doom.use_keybind)'
    for _, keybinds in ipairs(doom.binds) do
      nest_package.applyKeymaps(keybinds)
    end
  end, debug.traceback)
  if not ok and err then
    local log = require("doom.utils.logging")
    log.error(
      string.format(
        "There was an error setting keymaps for module '%s'. Traceback:\n%s",
        last_module,
        err
      )
    )
  end

end

return nest
