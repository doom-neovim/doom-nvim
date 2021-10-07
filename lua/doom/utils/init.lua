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

return utils
