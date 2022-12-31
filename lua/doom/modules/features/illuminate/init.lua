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
  local is_module_enabled = require("doom.utils").is_module_enabled
  vim.g.Illuminate_ftblacklist = doom.features.illuminate.settings.blacklist
  if is_module_enabled("features", "largefile") then
    require('illuminate').configure({
      large_file_cutoff = doom.features.largefile.settings.max_line_count
    })
  end
end

return illuminate
