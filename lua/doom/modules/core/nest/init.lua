local nest = {}

nest.settings = {
}

nest.uses = {
  ["nest.nvim"] = {
    "connorgmeehan/nest.nvim",
    branch = "integrations-api",
    after = "nvim-mapper",
  },
}

nest.configs = {}
nest.configs["nest.nvim"] = function()
  local utils = require("doom.utils")
  local is_plugin_disabled = utils.is_plugin_disabled

  local nest_package = require("nest")

  nest_package.enable(require("nest.integrations.mapper"))
  if not is_plugin_disabled("whichkey") then
    local whichkey_integration = require("nest.integrations.whichkey")
    nest_package.enable(whichkey_integration)
  end

  for _, module in pairs(doom.modules) do
    if module.binds then
      nest_package.applyKeymaps(type(module.binds) == 'function' and module.binds() or module.binds)
    end
  end
end

return nest
