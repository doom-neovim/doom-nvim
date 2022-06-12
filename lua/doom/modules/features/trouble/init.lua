local trouble = {}

trouble.settings = {}

trouble.packages = {
  ["trouble.nvim"] = {
    "folke/trouble.nvim",
    commit = "da61737d860ddc12f78e638152834487eabf0ee5",
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    opt = true,
  },
}

trouble.configs = {}
trouble.configs["trouble.nvim"] = function()
  require("trouble").setup(doom.features.trouble.settings)
end

trouble.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "T", "<cmd>TroubleToggle<CR>", name = "Trouble" },
      },
    },
    {
      "c",
      name = "+code",
      {
        { "e", "<cmd>TroubleToggle<CR>", name = "Open trouble" },
        {
          "d",
          name = "+diagnostics",
          {
            { "t", "<cmd>TroubleToggle<CR>", name = "Trouble" },
          },
        },
      },
    },
  },
}

return trouble
