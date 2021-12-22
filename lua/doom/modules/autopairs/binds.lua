local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "t",
        name = "+tweak",
        {
          { "p", require("doom.core.functions").toggle_autopairs, name = "Toggle autopairs" },
        },
      },
    },
  })
end

return binds
