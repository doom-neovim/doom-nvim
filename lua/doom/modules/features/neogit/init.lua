local neogit = {}

neogit.settings = {}

neogit.packages = {
  ["neogit"] = {
    "TimUntersberger/neogit",
    commit = "0ce803d22e361080ec0daf6bee7aad45e8cf8b07",
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
