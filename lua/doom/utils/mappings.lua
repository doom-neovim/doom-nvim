---[[---------------------------------------]]---
--         utils - Doom Nvim utilities         --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

--- @class mappings
local mappings = {}

local mod_utils = require("doom.utils.modules")

--- Mappings wrapper, extracted from
--- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L8-L12
--- https://github.com/lazytanuki/nvim-mapper#prevent-issues-when-module-is-not-installed
if mod_utils.is_module_available("nvim-mapper") then
  local mapper = require("nvim-mapper")

  mappings.map = function(mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map(mode, lhs, rhs, opts, category, unique_identifier, description)
  end
  mappings.map_buf = function(bufnr, mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map_buf(bufnr, mode, lhs, rhs, opts, category, unique_identifier, description)
  end
  mappings.map_virtual = function(mode, lhs, rhs, opts, category, unique_identifier, description)
    mapper.map_virtual(mode, lhs, rhs, opts, category, unique_identifier, description)
  end
  mappings.map_buf_virtual =
    function(mode, lhs, rhs, opts, category, unique_identifier, description)
      mapper.map_buf_virtual(mode, lhs, rhs, opts, category, unique_identifier, description)
    end
else
  local config = require("doom.core.config").config

  mappings.map = function(mode, lhs, rhs, opts, _, _, _)
    local options = config.doom.allow_default_keymaps_overriding and {} or { noremap = true }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
  mappings.map_buf = function(mode, lhs, rhs, opts, _, _, _)
    vim.api.nvim_buf_set_keymap(mode, lhs, rhs, opts)
  end
  mappings.map_virtual = function(_, _, _, _, _, _, _)
    return
  end
  mappings.map_buf_virtual = function(_, _, _, _, _, _, _)
    return
  end
end

--- keep functions that we want to call
--- @class functions
mappings.functions = {}

--- Execute the given lua functions
--- @param id number Index of the function in mappings.functions
mappings.execute = function(id)
  local func = mappings.functions[id]
  if not func then
    require("doom.extras.logging").error("Function doest not exist: " .. id)
  end
  return func()
end

-- map keybindings to functions and cmds
local function key_map(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})

  if type(cmd) == "function" then
    table.insert(mappings.functions, cmd)
    if opts.expr then
      cmd = ([[luaeval('require("doom.utils").execute(%d)')]]):format(#mappings.functions)
    else
      cmd = ("<cmd>lua require('doom.utils').execute(%d)<cr>"):format(#mappings.functions)
    end
  end
  if opts.buffer ~= nil then
    local buffer = opts.buffer
    opts.buffer = nil
    return vim.api.nvim_buf_set_keymap(buffer, mode, key, cmd, opts)
  else
    return vim.api.nvim_set_keymap(mode, key, cmd, opts)
  end
end

--- Map termcode keybindings
--- @param str string
--- @return string
mappings.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--- insert mode keybinding
--- @param key string
--- @param cmd string
--- @param opts table
mappings.imap = function(key, cmd, opts)
  return key_map("i", key, cmd, opts)
end

--- substitute mode keybinding
--- @param key string
--- @param cmd string
--- @param opts table
mappings.smap = function(key, cmd, opts)
  return key_map("s", key, cmd, opts)
end

return mappings
