---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

--- @class modules
local modules = {}

--- Check if a Lua module exists
--- @param mod string The module name, e.g. nvim-treesitter
--- @return boolean
modules.is_module_available = function(mod)
  if package.loaded[mod] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(mod)
      if type(loader) == "function" then
        package.preload[mod] = loader
        return true
      end
    end
    return false
  end
end

--- Load the specified Lua modules
--- @param module_path string The path to Lua modules, e.g. 'doom' → 'lua/doom'
--- @param mods table The modules that we want to load
modules.load_modules = function(module_path, mods)
  for i = 1, #mods, 1 do
    local ok, err = xpcall(require, debug.traceback, string.format("%s.%s", module_path, mods[i]))
    if not ok then
      require("doom.extras.logging").error(
        string.format(
          "There was an error loading the module '%s.%s'. Traceback:\n%s",
          module_path,
          mods[i],
          err
        )
      )
    else
      require("doom.extras.logging").debug(
        string.format("Successfully loaded '%s.%s' module", module_path, mods[i])
      )
    end
  end
end

return modules
