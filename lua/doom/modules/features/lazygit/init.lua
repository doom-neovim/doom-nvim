local lazygit = {}

lazygit.settings = {}

lazygit.uses = {
  ["lazygit.nvim"] = {
    "kdheepak/lazygit.nvim",
    commit = "9bceeab97668935cc6b91ab5190167d9771b5210",
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
        { "o", "<cmd>LazyGit<CR>", name = "Open lazygit" },
      },
    },
  },
}

return lazygit
