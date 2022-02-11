local terminal = {}

terminal.settings = {
  size = 10,
  open_mapping = "<F4>",
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  float_opts = {
    border = "curved",
    width = 70,
    height = 20,
    winblend = 0,
    highlights = {
      border = "Special",
      background = "Normal",
    },
  },
}

terminal.packages {
  ["toggleterm.nvim"] = {
    "akinsho/toggleterm.nvim",
    commit = "d2ceb2ca3268d09db3033b133c0ee4642e07f059",
    cmd = { "ToggleTerm", "TermExec" },
    opt = true,
  },
}

terminal.configure_functions = {}
terminal.configure_functions["toggleterm.nvim"] = function()
  require("toggleterm").setup(doom.modules.terminal.settings)
end

terminal.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "t", "<cmd>ToggleTerm<CR>", name = "Terminal" },
      },
    },
  },
}

return terminal
