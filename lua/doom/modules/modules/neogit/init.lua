local neogit = {}

neogit.settings = {}

neogit.packages = {
  ["neogit"] = {
    "TimUntersberger/neogit",
    commit = "cec7fd91ce9d7a5a5027e85eea961adfa4776dd4",
    cmd = "Neogit",
    opt = true,
  },
}

neogit.configs = {}
neogit.configs["neogit"] = function()
  require("neogit").setup(doom.modules.neogit.settings)
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
