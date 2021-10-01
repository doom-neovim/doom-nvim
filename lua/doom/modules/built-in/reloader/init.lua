--- @class Reloader
local reloader = {}

--- Reload a plugin configuration module
--- @param mod_path string The configuration module path
reloader.reload_plugin_config = function(mod_path)
  -- Remove the Neovim config dir and the file extension from the path,
  -- also replace '/' with '.' so we can access the modules by using package table
  -- e.g. doom.modules.config.doom-neorg
  mod_path = mod_path:gsub(vim.fn.stdpath("config") .. "/lua/", ""):gsub("/", "."):gsub(".lua", "")
  -- Get the module from package table
  local mod = package.loaded[mod_path]

  if type(mod) == "function" then
    -- Unload the module and load it again
    package.loaded[mod_path] = nil
    require(mod_path)
    -- Call the loaded module function so the reloading will take effect as expected
    package.loaded[mod_path]()

    require("doom.extras.logging").info(string.format("Successfully reloaded '%s' module", mod_path))
  else
    require("doom.extras.logging").error(string.format("Failed to reload '%s' module", mod_path))
  end
end

return reloader
