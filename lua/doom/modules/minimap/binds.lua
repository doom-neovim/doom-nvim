local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {
  { "<F5>", ":MinimapToggle<CR>", name = "Toggle minimap" },
}
if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "m", "<cmd>MinimapToggle<CR>", name = "Minimap" },
        },
      },
    },
  })
end

return binds
