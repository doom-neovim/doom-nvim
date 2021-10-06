--- @class Reloader
local reloader = {}

--- Reload a Lua module
--- @param mod_path string The configuration module path
--- @param quiet boolean If the reloader should send an info log or not
reloader.reload_lua_module = function(mod_path, quiet)
  -- Remove the Neovim config dir and the file extension from the path,
  -- also replace '/' with '.' so we can access the modules by using package table
  -- e.g. doom.modules.config.doom-neorg
  mod_path = mod_path:gsub(vim.fn.stdpath("config") .. "/lua/", ""):gsub("/", "."):gsub(".lua", "")
  -- Get the module from package table
  local mod = package.loaded[mod_path]

  if type(mod) ~= "nil" then
    -- Unload the module and load it again
    package.loaded[mod_path] = nil
    require(mod_path)

    if type(mod) == "function" then
      -- Call the loaded module function so the reloading will take effect as expected
      package.loaded[mod_path]()
    end

    if not quiet then
      require("doom.extras.logging").info(
        string.format("Successfully reloaded '%s' module", mod_path)
      )
    end
  else
    require("doom.extras.logging").error(string.format("Failed to reload '%s' module", mod_path))
  end
end

--- Reload the plugins definitions modules like doom_modules.lua to automatically
--- install or uninstall plugins on changes
reloader.reload_plugins_definitions = function()
  -- Silently reload plugins modules
  reloader.reload_lua_module("doom.core.config.modules", true)
  reloader.reload_lua_module("doom.core.config.userplugins", true)
  reloader.reload_lua_module("doom.modules", true)

  -- Cleanup disabled plugins
  vim.cmd("PackerClean")
  -- Defer the installation of new plugins to avoid a weird bug where packer
  -- tries to clean the plugins that are being installed right now
  vim.defer_fn(function()
    vim.cmd("PackerInstall")
  end, 200)
  vim.defer_fn(function()
    -- Compile plugins changes and simulate a new Neovim launch
    -- to load recently installed plugins
    -- NOTE: this won't work to live disable uninstalled plugins,
    --       they will keep working until you relaunch Neovim
    vim.cmd([[
      PackerCompile
      doautocmd VimEnter
    ]])
  end, 800)
end

return reloader
