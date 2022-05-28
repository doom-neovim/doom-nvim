local ts_playground = {}

ts_playground.settings = {}

ts_playground.packages = {
  ["playground"] = { "nvim-treesitter/playground" }, -- move to ts module.
}

ts_playground.binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  ts_playground.binds = {
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
end

return ts_playground
