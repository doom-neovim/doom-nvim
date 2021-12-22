local dap = {}

dap.defaults = {
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

dap.packer_config = {}
dap.packer_config["nvim-dap-ui"] = function()
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
  dapui.setup(doom.dap.dapui)
end

return dap
