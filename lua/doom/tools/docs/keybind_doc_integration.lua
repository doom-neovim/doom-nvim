-- This integration helps documentation generators by generating a markdown table containing all of the keymaps and keymap data
--
-- @example
-- local keybind_doc_integration = require('doom.tools.docs.keybind_doc_integration')
-- nest.enable(keybind_doc_integration)
-- keybind_doc_integration.set_table_fields({
--   {key = 'lhs', name = 'Keybind'},
--   {key = 'name', name = 'Name'},
--   {key = 'uid', name = 'Mapper ID'},
-- })
--
-- nest.traverse(keymaps, nil, { keybind_doc_integration })
--
-- local table_of_lines_of_markdown = keybind_doc_integration.print_markdown()
-- local 2d_list_of_table_data = keybind_doc_integration.get_rows()

--- @type NestIntegration
local module = {}
module.name = "keybind_doc_integration"

module.data = {}

--- @param node NestIntegrationNode
--- @param node_settings NestSettings
module.handler = function(node)
  -- If node.rhs is a table, this is a group of keymaps, if it is a string then it is a keymap
  local is_keymap_group = type(node.rhs) == "table"

  if not is_keymap_group then
    local row = {}
    for _, key in ipairs(module.keys) do
      table.insert(row, node[key] or "unset")
    end
    table.insert(module.data, row)
  end
end

module.set_table_fields = function(cols)
  module.keys = {}
  module.header = {}
  module.data = {}
  for _, col in ipairs(cols) do
    table.insert(module.keys, col.key)
    table.insert(module.header, col.name)
  end
end

module.get_rows = function()
  local result = {}
  table.insert(result, module.header)
  for _, row in ipairs(module.data) do
    table.insert(result, row)
  end
  return result
end

local pad_left = function(string, length, char)
  local c = char or " "
  local current_length = string.len(string)
  local difference = length - current_length
  if difference > 0 then
    for _ = 1, difference do
      string = c .. string
    end
  end
  return string
end

--- Returns a table of max length for each column
--- @param rows list<number, number>
local get_max_lengths = function(rows)
  local max_lengths = {}
  for _, _ in ipairs(rows[1]) do
    table.insert(max_lengths, 0)
  end

  for _, row in ipairs(rows) do
    for index, cell in ipairs(row) do
      print(
        index .. "| " .. cell .. " length is " .. string.len(cell) .. " vs " .. max_lengths[index]
      )
      max_lengths[index] = math.max(max_lengths[index], string.len(cell))
    end
  end
  return max_lengths
end

module.print_markdown = function()
  local max_lengths = get_max_lengths(module.get_rows())

  local result = {}

  -- Print header line and divider
  local header_line = "|"
  local divider_line = "|"
  for index, cell in ipairs(module.header) do
    header_line = header_line .. string.format(" %s |", pad_left(cell, max_lengths[index]))
    divider_line = divider_line .. string.format(" %s |", pad_left("", max_lengths[index], "-"))
  end
  table.insert(result, header_line)
  table.insert(result, divider_line)

  for _, row in ipairs(module.data) do
    local line = "|"
    for index, cell in ipairs(row) do
      line = line .. string.format(" %s |", pad_left(cell, max_lengths[index]))
    end
    table.insert(result, line)
  end

  for _, line in ipairs(result) do
    print(line)
  end

  return result
end

module.clear = function() end

return module
