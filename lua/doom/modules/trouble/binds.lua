local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "T", "<cmd>TroubleToggle<CR>", name = "Trouble" },
        },
      },
      {
        "c",
        name = "+code",
        {
          { "e", "<cmd>TroubleToggle<CR>", name = "Open trouble" },
          {
            "d",
            name = "+diagnostics",
            {
              { "t", "<cmd>TroubleToggle<CR>", name = "Trouble" },
            },
          },
        },
      },
    },
  })
end

return binds
