local illuminate = {}

illuminate.settings = {
  blacklist = {
    "help",
    "dashboard",
    "packer",
    "norg",
    "DoomInfo",
    "NvimTree",
    "Outline",
    "toggleterm",
  },
}

illuminate.packages = {
  ["vim-illuminate"] = {
    "RRethy/vim-illuminate",
    commit = "27f6ef135a88d9410a33cf92fc47f5c018df552c",
  },
}

illuminate.configs = {}
illuminate.configs["vim-illuminate"] = function()
  vim.g.Illuminate_ftblacklist = doom.features.illuminate.settings.blacklist
end

return illuminate
