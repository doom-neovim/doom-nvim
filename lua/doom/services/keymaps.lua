---
-- MIT License
--
-- Copyright (c) 2021 Leon Strauss, Connor Meehan
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local module = {}

--[[
--     TYPES
--]]

--- Extra options that will be passed to nvim when binding keymaps
--- @class NestSettingsOptions
--- @field noremap boolean
--- @field silent boolean
--- @field expr boolean

--- Stores the current keymap state/settings including lhs/prefix
--- @class NestSettings
--- @field buffer boolean|number
--- @field prefix string
--- @field options NestSettingsOptions
--- @field mode string

--- Internal type for a node in a nest.nvim config, this is how the end-user will define their config
--- @class NestNode : NestSettings
--- @field [1] string|table<number, NestNode>
--- @field [2] string|function|table<number,NestNode>
--- @field [3] string|nil Name
--- @field name string|nil Name
--- @field [4] string|nil Description
--- @field description string|nil Description

--- Type definition for nest.nvim integration
--- @class NestIntegration
--- @field name string
--- @field on_init function|nil
--- @field handler function
--- @field on_complete function|nil

--- Paramater passed to handler of NestIntegration
--- @class NestIntegrationNode
--- @field lhs string
--- @field rhs table<number, NestNode>|string
--- @field name string
--- @field description string

--[[
--     UTILS
--]]

--- Defaults being applied to `applyKeymaps`
-- Can be modified to change defaults applied.
--- @type NestSettings
module.defaults = {
  mode = "n",
  prefix = "",
  buffer = false,
  options = {
    noremap = true,
    silent = true,
  },
}

local function copy(table)
  return vim.deepcopy(table)
end

local function mergeTables(left, right)
  return vim.tbl_extend("force", left, right)
end

--- @param left NestSettings
--- @param right NestSettings
--- @return NestSettings
local function mergeSettings(left, right)
  local ret = copy(left)

  if right == nil then
    return ret
  end

  if right.mode ~= nil then
    ret.mode = right.mode
  end

  if right.buffer ~= nil then
    ret.buffer = right.buffer
  end

  if right.prefix ~= nil then
    ret.prefix = ret.prefix .. right.prefix
  end

  if right.options ~= nil then
    ret.options = mergeTables(ret.options, right.options)
  end

  return ret
end

--[[
--     INTEGRATIONS
--]]
-- Stores all the different handlers for the nest API
module.integrations = {}

-- Allows adding extra keymap integrations
--- @param integration NestIntegration
module.enable = function(integration)
  if integration.name ~= nil then
    module.integrations[integration.name] = integration
  end
end

--- Default nest integration that binds keymaps
--- @type NestIntegration
local default_integration = {}
default_integration.name = "nest"
default_integration.handler = function(node, node_settings)
  -- Skip tables (keymap groups)
  if type(node.rhs) == "table" then
    return
  end

  for mode in string.gmatch(node_settings.mode, ".") do
    local sanitizedMode = mode == "_" and "" or mode

    local buffer = (node_settings.buffer == true) and 0 or node_settings.buffer

    local options = vim.tbl_extend("force", {
      buffer = buffer
    }, node_settings.options)
    vim.keymap.set(sanitizedMode, node.lhs, node.rhs, options)
  end
end
-- Bind default_integration keymap handler
module.enable(default_integration)

--[[
--     TRAVERSING CONFIG
--]]

--- @param node NestNode
--- @param settings NestSettings
module.traverse = function(node, settings, integrations)
  local mergedSettings = mergeSettings(settings or module.defaults, node)

  local first = node[1]

  -- Top level of config, just traverse into each keymap/keymap group
  if type(first) == "table" then
    for _, sub_node in ipairs(node) do
      module.traverse(sub_node, mergedSettings, integrations)
    end
    return
  end

  -- First must be a string, append first to the prefix
  mergedSettings.prefix = mergedSettings.prefix .. first
  local second = node[2]

  --- @type string|table<number, NestNode>
  local rhs = second

  -- Populate node.name and node.description if necessary
  if node.name == nil and #node >= 3 then
    node.name = node[3]
  end
  if node.description == nil and #node >= 4 then
    node.description = node[4]
  end
  node.lhs = mergedSettings.prefix
  node.rhs = rhs

  -- Pass current keymap node to all integrations
  for _, integration in pairs(integrations) do
    integration.handler(node, mergedSettings)
  end

  if type(rhs) == "table" then
    module.traverse(rhs, mergedSettings, integrations)
  end
end

--[[
--    ENTRY POINT
--]]

--- Applies the given `keymapConfig`, creating nvim keymaps
--- @param nest_config table<number, NestNode>
--- @param settings NestSettings
--- @param integrations table<number, NestIntegration> User can parse the nest config with a subset of integrations
module.applyKeymaps = function(nest_config, settings, integrations)
  local ints = integrations or module.integrations
  -- Run on init for each integration
  for _, integration in pairs(ints) do
    if integration.on_init ~= nil then
      integration.on_init(nest_config, settings)
    end
  end

  module.traverse(nest_config, settings, ints)

  for _, integration in pairs(ints) do
    if integration.on_complete ~= nil then
      integration.on_complete()
    end
  end
end

return module
