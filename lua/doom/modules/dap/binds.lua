local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "d",
        name = "+debug",
        {
          {
            "c",
            function()
              require("dap").continue()
            end,
            name = "Continue/Start",
          },
          {
            "d",
            function()
              require("dap").disconnect()
            end,
            name = "Disconnect",
          },
          {
            "e",
            function()
              require("dapui").eval()
            end,
            name = "Evaluate",
          },
          {
            mode = "v",
            {
              {
                "e",
                function()
                  require("dapui").eval()
                end,
                name = "Evaluate",
              },
            },
          },
          {
            "b",
            name = "+breakpoint",
            {
              {
                "b",
                function()
                  require("dap").toggle_breakpoint()
                end,
                name = "Toggle breakpoint",
              },
              {
                "c",
                function()
                  vim.fn.inputsave()
                  local condition = vim.fn.input("Condition: ")
                  vim.fn.inputrestore()
                  require("dap").toggle_breakpoint(condition)
                end,
                name = "Toggle",
              },
              {
                "h",
                function()
                  vim.fn.inputsave()
                  local number = vim.fn.input("Hit number: ")
                  vim.fn.inputrestore()
                  require("dap").toggle_breakpoint(nil, number)
                end,
                name = "Hit number",
              },
              {
                "l",
                function()
                  vim.fn.inputsave()
                  local msg = vim.fn.input("Message: ")
                  vim.fn.inputrestore()
                  require("dap").toggle_breakpoint(nil, nil, msg)
                end,
                name = "Log",
              },
            },
          },
        },
      },
      {
        "o",
        name = "+open",
        {
          {
            "d",
            function()
              require("dapui").toggle()
            end,
            name = "Debugger",
          },
        },
      },
    },
  })
end

return binds
