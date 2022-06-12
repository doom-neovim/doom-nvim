local help = {}

-- TODO:
--
--    > lua referene toc
--    > man ...
--    > help under cursor inner word
--

help.packages = {}

help.binds = {}

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(help.binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       "h",
--       name = "+help",
--       {
--         { "n", "<leader>hm", ":Man ", { silent = false }, "Man Page", "man_page", "Man Page" },
--         {
--           "n",
--           "<leader>hl",
--           ":help lua_reference_toc<CR>",
--           { silent = false },
--           "Lua Reference",
--           "lua_reference",
--           "Lua Reference",
--         },
--         {
--           "n",
--           "<leader>hw",
--           '"zyiw:h <c-r>z<cr>',
--           { silent = false },
--           "Help Inner Word",
--           "help_inner_word",
--           "Inner Word",
--         },
--         { "n", "<leader>hh", ":help ", { silent = false }, "Help", "help", "Help" },
--         {
--           "n",
--           "<leader>hc",
--           "<cmd>helpc<cr>",
--           { silent = false },
--           "Close Help",
--           "close_help",
--           "Close Help",
--         },
--       },
--     },
--   })
-- end

return help
