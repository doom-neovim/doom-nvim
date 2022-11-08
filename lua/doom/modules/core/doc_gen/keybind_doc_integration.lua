--- @type NestIntegration
local module = {}
module.name = "keybind_doc_integration"

module.data = {}

--- @param node NestIntegrationNode
module.handler = function(node)
  -- If node.rhs is a table, this is a group of keymaps, if it is a string then it is a keymap
  local is_keymap_group = type(node.rhs) == "table"

  if not is_keymap_group then
    table.insert(module.data, node)
  end
end

module.clear = function()
  module.data = {}
end

return module
