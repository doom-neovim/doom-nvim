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

symbols.uses = {
  ["symbols-outline.nvim"] = {
    "simrat39/symbols-outline.nvim",
    commit = "758944ebc6919c50557b6eb3a52bc41187041fe2",
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
  vim.g.symbols_outline = doom.modules.symbols.settings
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
  }
}

return symbols
