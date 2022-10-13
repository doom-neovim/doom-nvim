--- AutoCommands Service,
--- Provides functions to wrap neovims APIs to set and remove autocmds
--- Acts as a compatibility layer between different API versions.
--- Manages references to all commands to be cleared for :DoomReload

-- TYPES

--- @class AutoCommandArgs
--- @field args string Args parsed to command (if any)
--- @field fargs string[] Args split by unescaped whitespace (if any)
--- @field line1 number Starting line of the command range
--- @field line2 number Final line of the command range
--- @field count number Any count supplied (if any)

--- @class SetAutoCommandOptions
--- @field nested boolean|nil
--- @field once boolean|nil

--- IMPLEMENTATIONS
--- Wraps the nvim functionality to handle different neovim versions.
local utils = require("doom.utils")

-- Data to be stored globally so it can be accessed from the nvim-0.5 implementation
local data = _G._doom_autocmds_service_data
  or {
    -- Stores data relating to the auto command so they can be deleted on neovim < 0.8
    autocmd_signatures = {},
    -- Stores the lua function handlers for nvim version < 0.8
    autocmd_actions = {},
    -- Stores created autocommand ids from vim.api.nvim_create_autocmd (or custom shim in the v0.5 version)
    autocmd_ids = {},
  }
_G._doom_autocmds_service_data = data

-- Store all autocommands inside of an augroup for doom-nvim
if vim.fn.has("nvim-0.8") then
  vim.api.nvim_create_augroup("DoomAutoCommands", { clear = true })
else
  vim.cmd([[
    augroup DoomAutoCommands
      autocmd!
    augroup END
  ]])
end

local set_autocmd_implementations = {
  ["nvim-0.5"] = function(event, pattern, action, opts)
    local cmd_string = "autocmd! "
    cmd_string = cmd_string .. ("%s %s "):format(event, pattern)

    local uid = utils.unique_index()
    data.autocmd_ids[uid] = true
    data.autocmd_signatures = cmd_string

    if opts.nested then
      cmd_string = cmd_string .. "++nested "
    end
    if opts.once then
      cmd_string = cmd_string .. "++once "
    end

    if type(action) == "string" then
      cmd_string = cmd_string .. action .. " "
    else
      data.autocmd_actions[uid] = action

      cmd_string = cmd_string
        .. (":lua _doom_autocmds_service_data.autocmd_actions[%d]()"):format(uid)
    end
    vim.cmd(cmd_string)
    return uid
  end,
  ["latest"] = function(event, pattern, action, opts)
    local merged_opts = vim.tbl_extend("keep", opts, {
      pattern = pattern,
      group = "DoomAutoCommands",
    })
    if type(action) == "function" then
      merged_opts.callback = action
    else
      merged_opts.command = action
    end

    local id = vim.api.nvim_create_autocmd(event, merged_opts)
    data.autocmd_ids[id] = true
    data.autocmd_signatures[id] = ("%s %s"):format(event, pattern)
    return id
  end,
}
local set_autocmd_fn = utils.pick_compatible_field(set_autocmd_implementations)

local del_autocmd_implementations = {
  ["nvim-0.5"] = function(id)
    local delete_signature = data.autocmd_signatures[id]
    if delete_signature then
      vim.cmd(delete_signature)
    end
  end,
  ["latest"] = function(id)
    vim.api.nvim_del_autocmd(id)
  end,
}
local del_autocmd_fn = utils.pick_compatible_field(del_autocmd_implementations)

local del_all_autocmd_implementations = {
  ["nvim-0.5"] = function()
    vim.cmd([[
      augroup DoomAutoCommands
        autocmd!
      augroup END
    ]])
  end,
  ["latest"] = function()
    vim.api.nvim_create_augroup("DoomAutoCommands", { clear = true })
  end,
}
local del_all_autocmd_fn = utils.pick_compatible_field(del_all_autocmd_implementations)

-- API
local autocmds_service = {}

--- Set a neovim autocmd
---@param event string Name of autocmd
---@param pattern string Pattern to match autocommand with
---@param action string|function(AutoCommandArgs)
---@param opts SetAutoCommandOptions|nil
---@return number ID of autocommand, used to delete it later on
autocmds_service.set = function(event, pattern, action, opts)
  local resolved_opts = opts or {}
  local stripped_opts = {
    nested = resolved_opts.nested or false,
    once = resolved_opts.once or false,
  }
  return set_autocmd_fn(event, pattern, action, stripped_opts)
end

--- Deletes an autocommand from a given id
---@param id number ID of autocommand to delete
autocmds_service.del = function(id)
  del_autocmd_fn(id)
  data.autocmd_ids[id] = nil
  data.autocmd_signatures[id] = nil
  data.autocmd_actions[id] = nil
end

autocmds_service.del_all = function()
  del_all_autocmd_fn()
end

return autocmds_service
