local neogit = {}

neogit.settings = {}

neogit.packages = {
  ["neogit"] = {
    "TimUntersberger/neogit",
    commit = "05386ff1e9da447d4688525d64f7611c863f05ca",
    cmd = "Neogit",
    opt = true,
  },
}

neogit.configs = {}
neogit.configs["neogit"] = function()
  require("neogit").setup(doom.features.neogit.settings)
end

neogit.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "g", "<cmd>Neogit<CR>", name = "Neogit" },
      },
    },
    {
      "g",
      name = "+git",
      {
        { "g", "<cmd>Neogit<CR>", name = "Open neogit" },
      },
    },
  },
}

return neogit
