--- Commands Service,
--- Provides functions to wrap neovims APIs to set and remove commands
--- Acts as a compatibility layer between different API versions.
--- Manages references to all commands to be cleared for :DoomReload

-- TYPES

--- @class CommandArgs
--- @field args string Args parsed to command (if any)
--- @field fargs string[] Args split by unescaped whitespace (if any)
--- @field line1 number Starting line of the command range
--- @field line2 number Final line of the command range
--- @field count number Any count supplied (if any)

--- @class SetCommandOptions
--- @field nargs number|'*'|nil Number of expected arguments for the command. '*' for variable.

--- IMPLEMENTATIONS
--- Wraps the nvim functionality to handle different neovim versions.
local utils = require("doom.utils")

-- Data to be stored globally so it can be accessed from the nvim-0.5 implementation
local data = _G._doom_commands_service_data or {
  command_actions = {},
}
_G._doom_commands_service_data = data

local set_command_implementations = {
  ["nvim-0.5"] = function(name, command, opts)
    -- Build the command constructor
    local cmd_string = "command! "
    if opts and opts.nargs ~= nil then
      cmd_string = cmd_string .. ("-nargs=%s "):format(opts.nargs)
    end
    if opts and opts.completion ~= nil then
      cmd_string = cmd_string .. ("-complete=%s "):format(table.concat(opts.complete, ","))
    end
    cmd_string = cmd_string .. " " .. name .. " "

    if type(command) == "string" then
      cmd_string = cmd_string .. command .. " "
    else
      local uid = utils.unique_index()
      data.command_actions[uid] = command

      cmd_string = cmd_string .. ("lua _doom_commands_service_data.command_actions[%d]"):format(uid)
      if opts.nargs ~= nil then
        cmd_string = cmd_string .. "(<f-args>)"
      else
        cmd_string = cmd_string .. "()"
      end
    end
    vim.cmd(cmd_string)
  end,
  ["nvim-0.8"] = function(name, command, opts)
    vim.api.nvim_create_user_command(name, command, opts)
  end,
}
local set_command_fn = utils.pick_compatible_field(set_command_implementations)

local del_command_implementations = {
  ["nvim-0.5"] = function(name)
    vim.cmd(("delcommand %s"):format(name))
  end,
  ["nvim-0.8"] = function(name)
    vim.api.nvim_del_user_command(name)
  end,
}
local del_command_fn = utils.pick_compatible_field(del_command_implementations)

-- API
local commands_service = {}

--- List of all commands set so they can be deleted by `commands.del_all()`
--- @type table<string,boolean|nil>
commands_service.stored_names = {}

--- Set a neovim command
---@param name string Name of command
---@param command string|function(CommandArgs)
---@param opts SetCommandOptions|nil
commands_service.set = function(name, command, opts)
  commands_service.stored_names[name] = true
  set_command_fn(name, command, opts or {})
end

commands_service.del = function(name)
  commands_service.stored_names[name] = nil
  del_command_fn(name)
end

commands_service.del_all = function()
  for name, _ in pairs(commands_service.stored_names) do
    if name then
      del_command_fn(name)
    end
  end
  commands_service.stored_names = {}
end

return commands_service
