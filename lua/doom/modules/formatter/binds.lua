local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "c",
        name = "+code",
        {
          { "f", "<cmd>FormatWrite<CR>", name = "Format" },
        },
      },
    },
  })
end

return binds
