local lazygit = {}

lazygit.settings = {}

lazygit.packages = {
  ["lazygit.nvim"] = {
    "kdheepak/lazygit.nvim",
    commit = "32bffdebe273e571588f25c8a708ca7297928617",
    cmd = { "LazyGit", "LazyGitConfig" },
    lazy = true,
  },
}

lazygit.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "l", "<cmd>LazyGit<CR>", name = "Lazygit" },
      },
    },
    {
      "g",
      name = "+git",
      {
        { "o", "<cmd>LazyGit<CR>", name = "Open lazygit" },
      },
    },
  },
}

return lazygit
