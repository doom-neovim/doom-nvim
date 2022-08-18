local symbols = {}

symbols.settings = {
  highlight_hovered_item = true,
  show_guides = true,
  position = "right",
  keymaps = {
    close = "<Esc>",
    goto_location = "<CR>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    rename_symbol = "r",
    code_actions = "a",
  },
  lsp_blacklist = {},
  width = 25,
}

symbols.packages = {
  ["symbols-outline.nvim"] = {
    "simrat39/symbols-outline.nvim",
    commit = "e459f3262c4c79a62e654ada0fbbb9758313c968",
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
    opt = true,
  },
}

symbols.configs = {}
symbols.configs["symbols_outline.nvim"] = function()
  vim.g.symbols_outline = doom.features.symbols.settings
end

symbols.binds = {
  { "<F2>", ":SymbolsOutline<CR>", name = "Toggle symbols outline" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "s", "<cmd>SymbolsOutline<CR>", name = "Symbol outline" },
        },
      },
    },
  },
}

return symbols
