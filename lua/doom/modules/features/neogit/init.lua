local neogit = {}

neogit.settings = {}

neogit.packages = {
  ["neogit"] = {
    "NeogitOrg/neogit",
    commit = "28b0227405e135424a79824ff6b840897cb4aba5",
    cmd = "Neogit",
    lazy = true,
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
