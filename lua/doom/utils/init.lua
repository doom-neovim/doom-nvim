---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

--- @class utils
local utils = {}

local system = require("doom.core.system")

-------------------- HELPERS --------------------
--- Doom Nvim version
utils.doom_version = "3.2.0-beta2"

--- For autocommands, extracted from
--- https://github.com/norcalli/nvim_utils
---
utils.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup " .. group_name)
    vim.api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command("augroup END")
  end
end

--- Check if string is empty or if it's nil
--- @param str string The string to be checked
--- @return boolean
utils.is_empty = function(str)
  return str == "" or str == nil
end

utils.escape_str = function(str)
  local escape_patterns = {
    "%^",
    "%$",
    "%(",
    "%)",
    "%[",
    "%]",
    "%%",
    "%.",
    "%-",
    "%*",
    "%+",
    "%?",
  }

  return str:gsub(("([%s])"):format(table.concat(escape_patterns)), "%%%1")
end

--- Search if a table have the value we are looking for,
--- useful for plugins management
--- @param tabl table
--- @param val any
--- @return boolean
utils.has_value = function(tabl, val)
  for _, value in ipairs(tabl) do
    if value == val then
      return true
    end
  end

  return false
end

--- Search if a table have the key we are looking for,
--- useful for plugins management
--- @param tabl table
--- @param key string
--- @return boolean
utils.has_key = function(tabl, key)
  for _, k in ipairs(vim.tbl_keys(tabl)) do
    if k == key then
      return true
    end
  end

  return false
end

--- Executes a git command and gets the output
--- @param command string
--- @param remove_newlines boolean
--- @return string
utils.get_git_output = function(command, remove_newlines)
  local git_command_handler = io.popen(system.git_workspace .. command)
  -- Read the command output and remove newlines if wanted
  local command_output = git_command_handler:read("*a")
  if remove_newlines then
    command_output = command_output:gsub("[\r\n]", "")
  end
  -- Close child process
  git_command_handler:close()

  return command_output
end

--- Check if the given plugin is disabled in doom_modules.lua
--- @param plugin string The plugin identifier, e.g. statusline
--- @return boolean
utils.is_plugin_disabled = function(plugin)
  local modules = require("doom.core.config.modules").modules

  -- Iterate over all modules sections (e.g. ui) and their plugins
  for _, section in pairs(modules) do
    if utils.has_value(section, plugin) then
      return false
    end
  end

  return true
end

-- Check if the given plugin exists
-- @param plugin_name string The plugin name, e.g. nvim-tree.lua
-- @param path string Where should be searched the plugin in packer's path, defaults to `start`
-- @return boolean
utils.check_plugin = function(plugin_name, path)
  if not path then
    path = "start"
  end

  return vim.fn.isdirectory(
    vim.fn.stdpath("data") .. "/site/pack/packer/" .. path .. "/" .. plugin_name
  ) == 1
end

return utils
