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

illuminate.uses = {
  ["vim-illuminate"] = {
    "RRethy/vim-illuminate",
    commit = "487563de7ed6195fd46da178cb38dc1ff110c1ce",
  },
}

illuminate.configs = {}
illuminate.configs["vim-illuminate"] = function()
  vim.g.Illuminate_ftblacklist = doom.modules.illuminate.settings.blacklist
end

return illuminate
