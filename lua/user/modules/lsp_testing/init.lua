local lsp_testing = {}

lsp_testing.settings = {}

-- read the lsp manual and find out how I can make a command
-- based on lsp. print something or whatever.
--
-- :h lsp lua

lsp_testing.cmds = {
  {
    "",
    function()
      print("ts-testing -> ")
    end,
  },
  {
    "",
    function()
      -- ??
      -- nui menu > select what to highlight.
    end,
  },
}

-- if require("doom.utils").is_module_enabled("whichkey") then
--   lsp_testing.binds = {
--     {
--       "<leader>M",
--       name = "+moll",
--       {
--         { "i", "<cmd>:BindsCreateGetInput<CR>", name = "creab binds test input" },
--         { "I", "<cmd>:MiniSyntaxTest<CR>", name = "create binds syntax test" },
--       },
--     },
--   }
-- end

return lsp_testing
