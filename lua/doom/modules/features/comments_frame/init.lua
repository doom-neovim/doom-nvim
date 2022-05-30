local tsp = {}

-- https://github.com/s1n7ax/nvim-comment-frame

tsp.packages = {
  ["nvim-comment-frame"] = {"s1n7ax/nvim-comment-frame"} -- create comment blocks per language
}

-- tsp.binds = {
--   {
--     "<leader>n",
--     name = "+test",
--     {
--       {
--         "t",
--         name = "+ts",
--         {
--           { "p", "<cmd>TSPlaygroundToggle<CR>", name = "togl playgr" },
--           { "h", "<cmd>TSHighlightCapturesUnderCursor<CR>", name = "highl capt curs" },
--           { "u", "<cmd>TSNodeUnderCursor<CR>", name = "node under curs" },
--         },
--       },
--     },
--   },
-- }

return tsp
