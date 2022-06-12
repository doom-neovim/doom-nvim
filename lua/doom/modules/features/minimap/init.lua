local minimap = {}

minimap.settings = {}

minimap.packages = {
  ["minimap.vim"] = {
    "wfxr/minimap.vim",
    commit = "5d44fe7a3a5f7041c4220a71e8fe83d8c8498042",
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
  }
}

return minimap
