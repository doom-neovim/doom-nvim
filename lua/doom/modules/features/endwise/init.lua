local tsp = {}


tsp.packages = {
  ["nvim-treesitter-endwise"] = {"RRethy/nvim-treesitter-endwise"},
}


tsp.binds = {
  {
    "<leader>n",
    name = "+test",
    {
      {
        "t",
        name = "+ts",
        {
          { "p", "<cmd>TSPlaygroundToggle<CR>", name = "togl playgr" },
          { "h", "<cmd>TSHighlightCapturesUnderCursor<CR>", name = "highl capt curs" },
          { "u", "<cmd>TSNodeUnderCursor<CR>", name = "node under curs" },
        },
      },
    },
  },
}

return tsp
