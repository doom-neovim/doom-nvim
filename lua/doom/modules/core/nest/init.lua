local nest = {}

nest.settings = {
}

nest.packages = {
  ["nest.nvim"] = {
    "connorgmeehan/nest.nvim",
    branch = "integrations-api",
  },
  ["nvim-mapper"] = {
    "lazytanuki/nvim-mapper",
    after = "nest.nvim",
  }
}

nest.configs = {}
nest.configs["nest.nvim"] = function()
  local utils = require("doom.utils")
  local is_module_enabled = utils.is_module_enabled

  local nest_package = require("nest")

  if is_module_enabled("whichkey") then
    local whichkey_integration = require("nest.integrations.whichkey")
    nest_package.enable(whichkey_integration)
  end

  local last_module = ""

  local ok, err = xpcall(function()
    for _, section_name in ipairs({"core", "modules", "langs", "user"}) do
      for module_name, module in ipairs(doom[section_name]) do
        last_module = module_name
        if module.binds then
          -- table.insert(all_keymaps, type(module.binds) == "function" and module.binds() or module.binds)
          nest_package.applyKeymaps(
            type(module.binds) == "function" and module.binds() or module.binds
          )
        end
      end
    end
    -- Apply user keybinds
    last_module = "user provided keybinds  (doom.use_keybind)"
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

nest.configs["nvim-mapper"] = function()
  require("nvim-mapper").setup(doom.core.doom.settings.mapper)
  local nest_package = require("nest")
  local mapper_integration = require("nest.integrations.mapper")

  local count = 0
  for _, section_name in ipairs({"core", "modules", "langs", "user"}) do
    for _, module in pairs(doom[section_name]) do
      if module.binds then
        count = count + 1
        vim.defer_fn(function()
          -- table.insert(all_keymaps, type(module.binds) == "function" and module.binds() or module.binds)
          nest_package.applyKeymaps(
            type(module.binds) == "function" and module.binds() or module.binds
          , nil, { mapper_integration })
        end, count)
      end
    end
  end
end

return nest
