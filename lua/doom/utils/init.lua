---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

--- @class utils
local utils = {}

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

return utils
