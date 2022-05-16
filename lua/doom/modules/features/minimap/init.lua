local minimap = {}

minimap.settings = {}

minimap.packages = {
  ["minimap.vim"] = {
    "wfxr/minimap.vim",
    commit = "b421e4ef008fb2c231e9ada2acffe502b21a4710",
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
