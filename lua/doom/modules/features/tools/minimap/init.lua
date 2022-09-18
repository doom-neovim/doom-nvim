local minimap = {}

minimap.settings = {}

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
