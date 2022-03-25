local minimap = {}

minimap.settings = {}

minimap.packages = {
  ["minimap.vim"] = {
    "wfxr/minimap.vim",
    commit = "c8ea2a5550b95b007631bc83908c48a3368eb57c",
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
