local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "b",
        name = "+buffer",
        {
          {
            "n",
            function()
              require("bufferline").cycle(1)
            end,
            name = "Jump to next",
          },
          {
            "]",
            function()
              require("bufferline").cycle(1)
            end,
            name = "Jump to next",
          },
          {
            "p",
            function()
              require("bufferline").cycle(-1)
            end,
            name = "Jump to prev",
          },
          {
            "[",
            function()
              require("bufferline").cycle(-1)
            end,
            name = "Jump to prev",
          },
        },
      },
    },
  })
end

return binds
