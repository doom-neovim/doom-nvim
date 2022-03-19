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

dap.uses = {
  ["nvim-dap"] = {
    "mfussenegger/nvim-dap",
    commit = "9fcff6e02e1a549d47a2c559a4b833798537c0bc",
    module = "dap",
  },
  ["nvim-dap-ui"] = {
    "rcarriga/nvim-dap-ui",
    commit = "22e94f2303c8d8d72b541799d7733c5ded0733c5",
    after = { "nvim-dap", "nest.nvim" },
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
  dapui.setup(doom.modules.dap.settings.dapui)
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
