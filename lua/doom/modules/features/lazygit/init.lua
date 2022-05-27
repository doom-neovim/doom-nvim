local lazygit = {}

lazygit.settings = {}

lazygit.packages = {
  ["lazygit.nvim"] = {
    "kdheepak/lazygit.nvim",
    commit = "68407ff60c1abe56cecedd4bec41380df5070a21",
    cmd = { "LazyGit", "LazyGitConfig" },
    opt = true,
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
        { "l", "<cmd>LazyGit<CR>", name = "Open Lazygit" },
      },
    },
  },
}

return lazygit
