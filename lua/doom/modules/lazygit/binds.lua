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
          { "l", "<cmd>LazyGit<CR>", name = "Lazygit" },
        },
      },
      {
        "g",
        name = "+git",
        {
          { "o", "<cmd>LazyGit<CR>", name = "Open lazygit" },
        },
      },
    },
  })
end

return binds
