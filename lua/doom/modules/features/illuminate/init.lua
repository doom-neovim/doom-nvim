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
    commit = "c82e6d04f27a41d7fdcad9be0bce5bb59fcb78e5",
  },
}

illuminate.configs = {}
illuminate.configs["vim-illuminate"] = function()
  vim.g.Illuminate_ftblacklist = doom.features.illuminate.settings.blacklist
end

return illuminate
