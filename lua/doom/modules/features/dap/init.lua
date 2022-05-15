local dap = {}

dap.settings = {
  debugger_dir = vim.fn.stdpath("data") .. "/dapinstall/",
  debugger_map = {},
  dapui = {
    icons = {
      expanded = "▾",
      collapsed = "▸",
    },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
    },
    sidebar = {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    tray = {
      elements = {
        "repl",
      },
      size = 10,
      position = "bottom",
    },
  },
}

dap.packages = {
  ["nvim-dap"] = {
    "mfussenegger/nvim-dap",
    commit = "d73ebd6953d11cb80804f39d73d4c49c6bb0abc2",
    module = "dap",
  },
  ["nvim-dap-ui"] = {
    "rcarriga/nvim-dap-ui",
    commit = "3eec5258c620e2b7b688676be8fb2e9a8ae436b2",
    after = { "nvim-dap" },
  },
}

dap.configs = {}
dap.configs["nvim-dap-ui"] = function()
  local dap_package = require("dap")
  local dapui = require("dapui")
  dap_package.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap_package.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap_package.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
  dapui.setup(doom.features.dap.settings.dapui)
end

dap.binds = {
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
  }

return dap
