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
    commit = "db98338285574265a6ce54370b54d9f939e091bb",
  },
}

illuminate.configure_functions = {}
illuminate.configure_functions["vim-illuminate"] = function()
  vim.g.Illuminate_ftblacklist = doom.modules.illuminate.settings.blacklist
end

return illuminate
