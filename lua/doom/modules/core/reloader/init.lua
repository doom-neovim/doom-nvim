--- @class Reloader
local reloader = {}

--- Only show error reloading message once per session
reloader.has_failed_reload = false

local fs = require("doom.utils.fs")
local utils = require("doom.utils")
local log = require("doom.utils.logging")
local system = require("doom.core.system")

--- Paths to reload plugins
local plugins_files_path = string.format(
  "%s%ssite%spack%spacker%sstart%s*",
  vim.fn.stdpath("data"),
  system.sep,
  system.sep,
  system.sep,
  system.sep,
  system.sep
)
local vim_subdirs = { "doc", "after", "syntax", "plugin" }

-- Should cause error if plenary is not installed.
xpcall(require, debug.traceback, "plenary")

--- Converts a Lua module path into an acceptable Lua module format
--- @param module_path string The path to the module
--- @return string|nil
local function path_to_lua_module(module_path)
  local lua_path = string.format("%s%slua", system.doom_root, system.sep)

  -- Remove the Neovim config dir and the file extension from the path
  module_path = string.match(
    module_path,
    string.format("%s%s(.*)%%.lua", utils.escape_str(lua_path), system.sep)
  )

  if not module_path then
    return nil
  end

  -- Replace '/' with '.' to follow the common Lua modules format
  module_path = module_path:gsub(system.sep, ".")

  -- Remove '.init' if the module ends with it
  module_path = module_path:gsub("%.init$", "")

  return module_path
end

--- Gets the runtime files found in the given path
--- @param parent_path string The parent path to look for files
--- @return table
local function get_runtime_files(parent_path)
  local scan_dir = require("plenary.scandir").scan_dir
  local runtime_files = {}

  -- Look in each Neovim subdir for runtime files (documentation, syntax files, etc)
  for _, subdir in ipairs(vim_subdirs) do
    local path = string.format("%s%s%s", parent_path, system.sep, subdir)

    if fs.file_exists(path) then
      local dir_files = {}
      -- We scan VimL and Lua files because some plugins has a 'plugin/foo.lua' file
      local dir_vim_files = scan_dir(path, { search_pattern = "%.vim$", hidden = true })
      local dir_lua_files = scan_dir(path, { search_pattern = "%.lua$", hidden = true })
      vim.list_extend(dir_files, dir_vim_files)
      vim.list_extend(dir_files, dir_lua_files)

      for _, file in ipairs(dir_files) do
        runtime_files[#runtime_files + 1] = file
      end
    end
  end

  return runtime_files
end

--- Gets all the Lua files found in '~/.config/nvim/lua' directory
--- @return table
local function get_lua_modules(path)
  local scan_dir = require("plenary.scandir").scan_dir
  -- Look for Lua modules in Doom Nvim root
  local modules = scan_dir(path, { search_pattern = "%.lua$", hidden = true })
  for idx, module in ipairs(modules) do
    module = path_to_lua_module(module)

    -- Override previous value with new value
    modules[idx] = module
  end

  return modules
end

--- Reloads all Neovim runtime files found in plugins
local function reload_runtime_files()
  local paths = vim.fn.glob(plugins_files_path, 0, 1)

  for _, path in ipairs(paths) do
    local runtime_files = get_runtime_files(path)

    for _, file in ipairs(runtime_files) do
      vim.cmd("silent! source " .. file)
    end
  end
end

--- Reload a Lua module
--- @param mod_path string The configuration module path
--- @param quiet boolean If the reloader should send an info log or not
reloader.reload_lua_module = function(mod_path, quiet)
  if mod_path:find("/") then
    mod_path = path_to_lua_module(mod_path)
  end

  -- If doom-nvim fails to reload, warn user once per session
  if mod_path == nil then
    if reloader.has_failed_reload == false then
      log.warn(
        "reloader: Failed to reload doom config because this file is not in nvim config directory.  Is your doom nvim config directory symlinked?"
      )
      reloader.has_failed_reload = true
    end
    return
  end

  -- Get the module from package table
  local mod = package.loaded[mod_path]

  -- Unload the module and load it again
  package.loaded[mod_path] = nil
  require(mod_path)

  if type(mod) == "function" then
    -- Call the loaded module function so the reloading will take effect as expected
    local ok, _ = xpcall(package.loaded[mod_path], debug.traceback)
    if not ok then
      log.error(string.format("Failed to reload '%s' module", mod_path))
    end
  end

  if not quiet then
    log.info(string.format("Successfully reloaded '%s' module", mod_path))
  end
end

--- Reload all Lua modules
--- @param quiet boolean If the reloader should send an info log or not
reloader.reload_lua_modules = function(quiet)
  local paths = vim.fn.glob(system.doom_root .. system.sep .. "lua", 0, 1)

  for _, path in ipairs(paths) do
    local modules = get_lua_modules(path)

    for _, module in ipairs(modules) do
      reloader.reload_lua_module(module, quiet)
    end
  end
end

--- Reload the plugin definitions modules like modules.lua to automatically
--- install or uninstall plugins on changes
reloader.reload_plugins_definitions = function()
  -- local old_modules = vim.deepcopy(require("doom.core.config.modules").modules)

  if _doom and _doom.cmd_funcs then
    _doom.cmd_funcs = {}
  end

  for k, _ in pairs(package.loaded) do
    if string.match(k, "^doom%.core") then
      package.loaded[k] = nil
    end
  end

  -- -- Silently reload plugins modules
  reloader.reload_lua_module("doom.core.config.modules", true)
  reloader.reload_lua_module("doom.core.config", true)
  require("doom.core.config"):load()
  -- -- Silently reload plugins modules
  reloader.reload_lua_module("doom.core", true)

  reloader.reload_lua_module("doom.modules", true)
  require("doom.modules"):load_modules()
  require("doom.modules"):handle_user_config()
  --
  vim.cmd('doautocmd VimEnter')
  --
  -- local new_modules = vim.deepcopy(require("doom.core.config.modules").modules)
  -- if vim.deep_equal(old_modules, new_modules) then
  --   vim.defer_fn(function()
  --     print("compile")
  --     vim.cmd('PackerCompile')
  --   end, 100)
  -- else
  --   vim.defer_fn(function()
  --     print("sync")
  --     vim.cmd('PackerSync')
  --   end, 100)
  -- end

end

--- Reload all Neovim configurations
reloader.reload_configs = function()
  --- Clear highlighting
  vim.cmd("hi clear")

  --- Restart running language servers
  if vim.fn.exists(":LspRestart") ~= 0 then
    vim.cmd("silent! LspRestart")
  end

  reloader.reload_plugins_definitions()

  vim.cmd("doautocmd VimEnter")
  -- vim.cmd("doautocmd BufEnter")
  vim.cmd("doautocmd ColorScheme")
  vim.cmd("doautocmd Syntax")
end

--- Reload Neovim and simulate a new run
reloader.full_reload = function()
  -- Store the time taken to reload Doom
  local reload_time = vim.fn.reltime()
  log.info("Reloading Doom ...")

  --- Reload Neovim configurations
  reloader.reload_configs()

  log.info(
    "Reloaded Doom in "
      .. vim.fn.printf("%.3f", vim.fn.reltimefloat(vim.fn.reltime(reload_time)))
      .. " seconds"
  )
end

reloader.settings = {
  reload_on_save = true,
}
reloader.packages = {}
reloader.configs = {}

reloader.cmds = {
  {
    "DoomReload",
    function()
      reloader.full_reload()
    end,
  },
}

reloader.autocmds = function()
  local autocmds = {}

  if reloader.settings.reload_on_save then
    -- table.insert(autocmds, { "BufWritePost", "*/doom/**/*.lua", function()
    --   reloader.full_reload()
    -- end, })
    table.insert(autocmds, {
      "BufWritePost",
      "*/modules.lua,*/config.lua",
      function()
        if vim.fn.getcwd() == vim.fn.stdpath("config") then
          reloader.full_reload()
        end
      end,
    })
  end

  return autocmds
end
return reloader
