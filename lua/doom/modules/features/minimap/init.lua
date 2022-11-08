local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.minimap
---@text # Code minimap
---
--- Shows a minimup of the open buffer
---

local minimap = DoomModule.new("minimap")

minimap.settings = {}

---@eval return doom.core.doc_gen.generate_packages_documentation("features.minimap")
minimap.packages = {
  ["minimap.vim"] = {
    "wfxr/minimap.vim",
    commit = "3801d9dfaa5431e7b83ae6f98423ac077d9f5c3f",
    opt = true,
    cmd = {
      "Minimap",
      "MinimapClose",
      "MinimapToggle",
      "MinimapRefresh",
      "MinimapUpdateHighlight",
    },
  },
}

minimap.configs = {}

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.minimap")
minimap.binds = {
  { "<F5>", ":MinimapToggle<CR>", name = "Toggle minimap" },
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "m", "<cmd>MinimapToggle<CR>", name = "Minimap" },
        },
      },
    },
  },
}

return minimap
