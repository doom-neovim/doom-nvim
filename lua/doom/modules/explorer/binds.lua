local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {
  { "<F3>", ":NvimTreeToggle<CR>", name = "Toggle file explorer" },
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
          { "e", "<cmd>NvimTreeToggle<CR>", name = "Explorer" },
        },
      },
    },
  })
end

return binds
