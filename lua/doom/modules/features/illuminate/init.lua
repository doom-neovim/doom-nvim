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
    commit = "0603e75fc4ecde1ee5a1b2fc8106ed6704f34d14",
  },
}

illuminate.configs = {}
illuminate.configs["vim-illuminate"] = function()
  vim.g.Illuminate_ftblacklist = doom.features.illuminate.settings.blacklist
end

return illuminate
