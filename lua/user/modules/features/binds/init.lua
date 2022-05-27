local paths = require("user.utils").paths

-----------------------------
---       READ FILE       ---
-----------------------------

-- -- navigation + rm arrows
-- {'i', '<Down>', '<Nop>' },
-- {'i', '<Left>', '<Nop>' },
-- {'i', '<Right>', '<Nop>' },
-- {'i', '<Up>', '<Nop>' },
-- {'n', '<Down>', '<Nop>' },
-- {'n', '<Left>', '<Nop>' },
-- {'n', '<Right>', '<Nop>' },
-- {'n', '<Up>', '<Nop>' },
-- {'v', '<Down>', '<Nop>' },
-- {'v', '<Left>', '<Nop>' },
-- {'v', '<Right>', '<Nop>' },
-- {'v', '<Up>', '<Nop>' },

-- -- ctrl move
-- {'i','<c-l>','<space>'},
-- {'c','<c-l>','<space>'},

----------------------------------
---       todo quicklist       ---
----------------------------------

-- { 'n', '<leader>Tq', '<cmd>TodoQuickFix<cr>',  {}, "Quick Fix", "todo_quick_fix", "Todo Quick Fix" },
-- { 'n', '<leader>Tt', '<cmd>TodoTrouble<cr>',   {}, "Trouble",   "todo_trouble", "Todo Trouble" },
-- { 'n', '<leader>Te', '<cmd>TodoTelescope<cr>', {}, "Telescope", "todo_telescope", "Todo Telescope" },
-- { 'n', '<leader>Tl', '<cmd>TodoLocList<cr>',   {}, "LocList",   "todo_loc_list", "Todo LocList" },

-----------------------
---       GIT       ---
-----------------------

-- TODO:
--
--  git reset
--	unstage all
--
--	split hunk ???????????????????????
--
--	reset hunk
--	reset buffer
--	reset hunk
--
--	partial hunks // https://github.com/lewis6991/gitsigns.nvim/pull/411

-- WHICH-KEY TREE
-- ["l"] = {
--   name = "+git-test",
--   ["zo"] = { "open lazygit" },
-- },

-- -- 1. unstage all
-- { 'n', '<leader>lgr', '<cmd>!git reset<cr>', opts.s },
-- -- 2. unstage all and stagu hunk under cursor
-- -- 3. triple -> unstage all, select at cursor, and commit
-- -- 4. unstage all and commit only current buffer.


-- -- -- GITSIGNS
-- { 'n', '<leader>lsn', '<cmd>lua require("gitsigns").next_hunk()<CR>', opts.s},
-- { 'n', '<leader>lsp', '<cmd>lua require("gitsigns").prev_hunk()<CR>', opts.s},
-- { 'n', '<leader>lss', '<cmd>lua require("gitsigns").stage_hunk()<CR>', opts.s},
-- { 'n', '<leader>lsu', '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>', opts.s},
-- { 'n', '<leader>lsb', '<cmd>lua require("gitsigns").stage_buffer()<CR>', opts.s},
-- -- TODO: diffthiss > diffview hunk at cursor
-- -- -- TODO: undo buffer
-- -- toggle_signs()
-- -- 	toggle_numhl()
-- -- 	toggle_linehl()
-- -- 	toggle_word_diff()
-- -- 	toggle_current_line_blame()
-- -- 	refresh()

-- -- -- DIFFVIEW
-- { 'n', '<leader>ldh', '<cmd>DiffviewOpen<CR>', opts.s},
-- { 'n', '<leader>ldc', '<cmd>DiffviewClose<CR>', opts.s},
-- { 'n', '<leader>ldH', '<cmd>DiffviewOpen HEAD~2<CR>', opts.s},
-- -- { 'n', '<leader>ldH', '<cmd>DiffviewOpen HEAD~2<CR>', opts.s}, -- TODO: prev commit
-- -- { 'n', '<leader>ldH', '<cmd>DiffviewOpen HEAD~2<CR>', opts.s}, -- TODO: HEAD prev HEAD

-- -- -- VGIT
-- { 'n', '<leader>lvb', '<cmd>lua require("vgit").buffer_hunk_preview()<CR>', opts.s},
-- { 'n', '<leader>lV', '<cmd>vgit<CR>', opts.s},

-- -- -- LAZYGIT
-- -- mappings.map("n", "<leader>go", "<cmd>LazyGit<CR>", opts, "Git", "lazygit", "Open LazyGit")
-- { 'n', '<leader>lzo', '<cmd>LazyGit<CR>', opts.s},

-- local bind = function(t)
--   print(t[1], t[2])
--   -- enabled?
--   if t[1] then
--     for key, mappings in pairs(t) do
--       print("type: ", type(key), key)
--       if type(key) ~= "number" then
--         print(key, "<<<<")
--         table.insert(doom.binds, mappings)
--       end
--     end
--   end
-- end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local binds = {}

-- search binds `/ and ?`

-- commandline binds

-- operator
table.insert(binds, {
  { "b", "vb", mode = "o", options = { silent = true, noremap = true } },
  { "B", "vB", mode = "o", options = { silent = true, noremap = true } },
  { "F", "vF", mode = "o", options = { silent = true, noremap = true } },
  { "T", "vT", mode = "o", options = { silent = true, noremap = true } },
  -- { 'o', 's', '<Plug>Lightspeed_s', options = { silent = true } },
  -- { 'o', 'S', '<Plug>Lightspeed_S', options = { silent = true, noremap = true } },
})

table.insert(binds, {
  { "<c-z>", [[<cmd>suspend<CR>]], name = "suspend vim" },
  { "<c-z>", [[<Esc><cmd>suspend<CR>]], name = "suspend vim", mode = "v" },
  { ";", ":", name = "colon", options = { silent = false } },
  { ":", ";", name = "semi-colon" },
  --  {'n', 'dl', ':set wrap! linebreak!<CR>'},
  -- { 'x', 'z', '<Plug>VSurround' },
  -- { 'n', 'yzz', '<Plug>Yssurround' }, -- double ss
  -- { 'n', 'yz', '<Plug>Ysurround' }, -- single s
  -- { 'n', 'dz', '<Plug>Dsurround' },
  -- { 'n', 'cz', '<Plug>Csurround' },
  -- -- -- search regex
  -- -- {'n', '/', '/\\v'}, -- need to esc backsl
  -- -- {'v', '/', '/\\v'},
})

-- insert
table.insert(binds, {
  -- { "i", "zm", "<ESC>:w<cr>", opts_s, "Editor", "exit_insert", "Exit insert mode" },
  -- { "i", "zD", "<ESC>dF", opts_s, "Editor", "exit_insert_delete_bkw", "Exit insert mode and delete Backwards" },
  -- { "i", "zh", "<ESC>yF", opts_s, "Editor", "exit_insert_yank_bkw", "Exit insert mode and yank Backwards" },
  { "zf", "<ESC>cF", mode = "i", name = "esc search back", options = { silent = true } },
  -- { "i", "zt", "<ESC>cT", opts_s, "Editor", "exit_insert_till_bkw", "Exit insert mode and change Until Backwards" },
  {
    "zp",
    "<ESC>la",
    mode = "i",
    options = { silent = true },
    name = "Exit Insert Mode and append right",
  },
  {
    "zP",
    "<ESC>A ",
    mode = "i",
    options = { silent = true },
    name = "Exit Insert Mode and (A)ppend",
  },
})

-- visual
table.insert(binds, {
  -- [[ n | do something in normal mode | sn | "_dP ]],
  -- [[ v | copy text in paragraph      | n  | "_dP ]],
  { "p", '"_dP', mode = "v", options = { silent = false } },
  { "<c-z>", [[<Esc><cmd>suspend<CR>]], name = "suspend vim", mode = "v" },
  {
    "<C-l>v",
    '"zy:lua doom.moll.funcs.inspect(<c-r>z)<Left>',
    name = "inspect",
    options = { silent = false },
    mode = "v",
  },
  {
    "<C-l>i",
    [[:lua doom.moll.funcs.inspect(loadstring(doom.moll.funcs.get_visual_selection()))<CR>]],
    name = "print vis sel",
    options = { silent = true },
    mode = "v",
  },
})

-- -- terminal
-- table.insert(binds, {
-- })

-- quick file access
if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "M",
        name = "+moll",
        {
          {
            "g",
            name = "+go",
            {
              { "D", "<cmd>e " .. paths.doom_log_path .. "<CR>" },
              -- { "N", "<cmd>e " .. paths.notes_rndm .. "<CR>" },
              { "S", "<cmd>e " .. paths.conf_skhd .. "<CR>" },
              { "a", "<cmd>e " .. paths.conf_alac .. "<CR>" },
              { "e", "<cmd>e " .. paths.conf_setup .. "<CR>" },
              { "g", "<cmd>e " .. paths.aliases_git .. "<CR>" },
              { "m", "<cmd>e " .. paths.conf_tnx_main .. "<CR>" },
              -- { "n", "<cmd>e " .. paths.notes_todo .. "<CR>" },
              { "s", "<cmd>e " .. paths.conf_surf .. "<CR>" },
              { "t", "<cmd>e " .. paths.conf_tmux .. "<CR>" },
              { "x", "<cmd>e " .. paths.conf_scim .. "<CR>" },
              { "y", "<cmd>e " .. paths.conf_yabai .. "<CR>" },
              { "z", "<cmd>e " .. paths.aliases_zsh .. "<CR>" },
            },
          }, -- moll > go
        },
      },
    },
  })
end

-- leader
if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "M",
        name = "+moll",
        {
          {
            "l",
            [[<cmd>lua require("luasnip_snippets").load_snippets()<CR>]],
            name = "load luasnip-snippets",
          },
          { "r", [[<cmd>DoomReload<CR>]], name = "doomReload" },
          {
            "R",
            function()
              doom.moll.funcs.report_an_issue()
            end,
            name = "create_issue_from_templ",
          },
          {
            "p",
            [[:lua doom.moll.funcs.inspect(doom.)<Left>]],
            name = "inspect",
            options = { silent = false },
          },
          {
            "P",
            [[:lua doom.moll.funcs.inspect()<Left>]],
            name = "inspect",
            options = { silent = false },
          },
          {
            "w",
            '"zyiw:lua doom.moll.funcs.inspect(<c-r>z)<Left>',
            name = "inspect iw",
            options = { silent = false },
          },
          {
            "W",
            '"zyiW:lua doom.moll.funcs.inspect(<c-r>z)<Left>',
            name = "inspect iW",
            options = { silent = false },
          },
          { "t", '<cmd>TermExec cmd="zsh -il"<cr>', name = "terminal zsh -il" },
          -- {
          --     "e", name = "+TEST", {
          --       -- -- https://github.com/jbyuki/nabla.nvim#usage
          --       -- { 'n', '<F5>', '<cmd>lua require("nabla").action()<cr>', options = { noremap = true } },
          --       -- { 'n', '<leader>Tp', '<cmd>lua require("nabla").popup()<cr>', options = { noremap = true } },
          --       -- -- vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
          --       -- { 'n', '<leader>N', ':lua toggle_venn()<CR>', options = { noremap = true } },
          --           --       -- require("plenary.reload").reload_module(selection.value)
          --           -- -- { 'n', '<leader>lr', ':lua require("telescope.builtin").reloader({ cwd = ' .. test_plugin_reload .. '})<cr>', options = { noremap = true } },
          --           -- { 'n', '<leader>lr', ':lua require("plenary.reload").reload_module(' .. test_plugin_reload .. ')<cr>', options = { noremap = true } },
          --           -- { 'n', '<leader>lR', ':lua report_an_issue()<cr>', options = { noremap = true } },
          --           -- { 'n', '<leader>lp', ':lua pp()<left>', options = { noremap = true } },
          --
          --     }
          --   },
          -- {
          --     "L", name = "+line operations", {
          --       -- -- line operations (testing)
          --       -- -- " run current line through shell
          --       -- { 'n', ',Zs', '!!$SHELL <CR>'},
          --       -- -- " run current line in commandline
          --       -- { 'n', ',Zl', 'yy:@" <CR>' },
          --       -- ??
          --       -- { 'n', ',ZZ', ':w !sudo tee %'},
          --     }
          --   }
        },
      }, -- moll
    }, -- leader
  })
end

return { binds = binds }
