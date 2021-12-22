local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {
  { "<F2>", ":SymbolsOutline<CR>", name = "Toggle symbols outline" },
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
          { "c", "<cmd>SymbolsOutline<CR>", name = "Symbol outline" },
        },
      },
    },
  })
end

return binds
