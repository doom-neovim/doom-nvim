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
          { "g", "<cmd>Neogit<CR>", name = "Neogit" },
        },
      },
      {
        "g",
        name = "+git",
        {
          { "g", "<cmd>Neogit<CR>", name = "Open neogit" },
        },
      },
    },
  })
end

return binds
