local lazygit = {}

lazygit.settings = {}

lazygit.uses = {
  ["lazygit.nvim"] = {
    "kdheepak/lazygit.nvim",
    commit = "ca8ea75e5a1d838635fd2fcc5c3467a5bb33c4ec",
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
