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

terminal.packages = {
  ["toggleterm.nvim"] = {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {terminal.settings.open_mapping},
    lazy = true,
  },
}

terminal.configs = {}
terminal.configs["toggleterm.nvim"] = function()
  require("toggleterm").setup(doom.features.terminal.settings)
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

terminal.autocmds = {
  {
    "TermOpen",
    "*",
    "setlocal laststatus=0 noshowmode noruler nonumber norelativenumber",
  },
}

return terminal
