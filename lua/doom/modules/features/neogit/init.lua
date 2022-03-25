local neogit = {}

neogit.settings = {}

neogit.packages = {
  ["neogit"] = {
    "TimUntersberger/neogit",
    commit = "9987421e0724ce704d0035f50a7080c677a85d71",
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
