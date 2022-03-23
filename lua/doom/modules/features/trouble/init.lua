local trouble = {}

trouble.settings = {}

trouble.uses = {
  ["trouble.nvim"] = {
    "folke/trouble.nvim",
    commit = "691d490cc4eadc430d226fa7d77aaa84e2e0a125",
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    opt = true,
  },
}

trouble.configs = {}
trouble.configs["trouble.nvim"] = function()
  require("trouble").setup(doom.modules.trouble.settings)
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
