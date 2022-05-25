local binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "t",
        name = "+tweak",
        {
          { "w", require("doom.core.functions").toggle_wrap, name = "Toggle wrap" },
        },
      },
    },
  })
end

-- -- leader
-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "M",
--         name = "+moll",
--         {
--           {
--             "l",
--             [[<cmd>lua require("luasnip_snippets").load_snippets()<CR>]],
--             name = "load luasnip-snippets",
--           },
--           { "r", [[<cmd>DoomReload<CR>]], name = "doomReload" },
--           {
--             "R",
--             function()
--               doom.moll.funcs.report_an_issue()
--             end,
--             name = "create_issue_from_templ",
--           },
--           {
--             "p",
--             [[:lua doom.moll.funcs.inspect(doom.)<Left>]],
--             name = "inspect",
--             options = { silent = false },
--           },
--           {
--             "P",
--             [[:lua doom.moll.funcs.inspect()<Left>]],
--             name = "inspect",
--             options = { silent = false },
--           },
--           {
--             "w",
--             '"zyiw:lua doom.moll.funcs.inspect(<c-r>z)<Left>',
--             name = "inspect iw",
--             options = { silent = false },
--           },
--           {
--             "W",
--             '"zyiW:lua doom.moll.funcs.inspect(<c-r>z)<Left>',
--             name = "inspect iW",
--             options = { silent = false },
--           },
--           { "t", '<cmd>TermExec cmd="zsh -il"<cr>', name = "terminal zsh -il" },
--           -- {
--           --     "e", name = "+TEST", {
--           --       -- -- https://github.com/jbyuki/nabla.nvim#usage
--           --       -- { 'n', '<F5>', '<cmd>lua require("nabla").action()<cr>', options = { noremap = true } },
--           --       -- { 'n', '<leader>Tp', '<cmd>lua require("nabla").popup()<cr>', options = { noremap = true } },
--           --       -- -- vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
--           --       -- { 'n', '<leader>N', ':lua toggle_venn()<CR>', options = { noremap = true } },
--           --           --       -- require("plenary.reload").reload_module(selection.value)
--           --           -- -- { 'n', '<leader>lr', ':lua require("telescope.builtin").reloader({ cwd = ' .. test_plugin_reload .. '})<cr>', options = { noremap = true } },
--           --           -- { 'n', '<leader>lr', ':lua require("plenary.reload").reload_module(' .. test_plugin_reload .. ')<cr>', options = { noremap = true } },
--           --           -- { 'n', '<leader>lR', ':lua report_an_issue()<cr>', options = { noremap = true } },
--           --           -- { 'n', '<leader>lp', ':lua pp()<left>', options = { noremap = true } },
--           --
--           --     }
--           --   },
--           -- {
--           --     "L", name = "+line operations", {
--           --       -- -- line operations (testing)
--           --       -- -- " run current line through shell
--           --       -- { 'n', ',Zs', '!!$SHELL <CR>'},
--           --       -- -- " run current line in commandline
--           --       -- { 'n', ',Zl', 'yy:@" <CR>' },
--           --       -- ??
--           --       -- { 'n', ',ZZ', ':w !sudo tee %'},
--           --     }
--           --   }
--         },
--       }, -- moll
--     }, -- leader
--   })
-- end

return { binds = binds }
