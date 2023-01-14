local trouble = {}

trouble.settings = {}

trouble.packages = {
  ["trouble.nvim"] = {
    "folke/trouble.nvim",
    commit = "83ec606e7065adf134d17f4af6bae510e3c491c1",
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    lazy = true,
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
