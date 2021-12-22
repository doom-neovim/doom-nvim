local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = { "<F7>", "<cmd>RestNvim<CR>", name = "Open http client" }

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "h", "<cmd>RestNvim<CR>", name = "Http" },
        },
      },
    },
  })
end

return binds
