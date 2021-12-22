local illuminate = {}

illuminate.defaults = {
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

illuminate.packer_config = {}
illuminate.packer_config["vim-illuminate"] = function()
  vim.g.Illuminate_ftblacklist = doom.illuminate.blacklist
end

return illuminate
