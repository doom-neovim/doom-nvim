local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "q",
        name = "+quit",
        {
          {
            "r",
            function()
              require("persistence").load({ last = true })
            end,
            name = "Restore session",
          },
        },
      },
    },
  })
end

return binds
