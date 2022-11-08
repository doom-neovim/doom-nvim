local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.illuminate
---@text # Illuminate
---
--- Highlights matching words under the cursor
---

local illuminate = DoomModule.new("illuminate")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.illuminate")
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
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.illuminate")
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
