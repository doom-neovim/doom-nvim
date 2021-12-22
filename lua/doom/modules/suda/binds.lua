local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "f",
        name = "+file",
        {
          { "R", "<cmd>SudaRead<CR>", name = "Read with sudo" },
          { "W", "<cmd>SudaWrite<CR>", name = "Write with sudo" },
        },
      },
    },
  })
end

return binds
