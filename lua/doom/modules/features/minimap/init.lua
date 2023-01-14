local minimap = {}

minimap.settings = {}

minimap.packages = {
  ["minimap.vim"] = {
    "wfxr/minimap.vim",
    commit = "2b0151d7302f87f90c4664d119518dda73cc4633",
    lazy = true,
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
