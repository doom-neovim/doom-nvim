local tsp = {}

----------------------------
-- SETTINGS
----------------------------


-- tsp.settings = {}

----------------------------
-- PACKAGES
----------------------------

tsp.packages = {
  ["playground"] = { "nvim-treesitter/playground" }, -- move to ts module.
  ["nvim-treesitter-refactor"] = { "nvim-treesitter/nvim-treesitter-refactor" },
  ["complementree.nvim"] = { "vigoux/complementree.nvim" },
  -- ["ts-manipulator.nvim"] = {"akshettrj/ts-manipulator.nvim"},
  -- ["templar.nvim"] = {"vigoux/templar.nvim"},
  -- ["module-template"] = {"nvim-treesitter/module-template"},
  -- ["jump-from-treesitter.nvim"] = {"kizza/jump-from-treesitter.nvim"},
  -- ["ntangle-ts.nvim"] = {"jbyuki/ntangle-ts.nvim "},
  -- ["ts-word-wrapper.nvim"] = {"aaronma37/ts-word-wrapper.nvim"},
  -- ["proofreader.nvim"] = {"vigoux/proofreader.nvim"},
  -- ["sintax-tree-surfer"] = {"ziontee113/syntax-tree-surfer"},
  -- ["nvim-ts-rainbow"] = {"p00f/nvim-ts-rainbow"},
  -- ["nvim-yati"] = {"yioneko/nvim-yati"},
  -- ["docstr.nvim"] = {"Bryley/docstr.nvim"},
}

----------------------------
--
-- CONFIGS
--
----------------------------

-----------------------------------------------------------------------------
-- ::: NVIM TREESITTER REFACTOR ::: --
-----------------------------------------------------------------------------

-- lua <<EOF
-- require'nvim-treesitter.configs'.setup {
--   refactor = {
--     highlight_definitions = {
--       enable = true,
--       -- Set to false if you have an `updatetime` of ~100.
--       clear_on_cursor_move = true,
--     },
--   },
-- }
-- EOF

-- lua <<EOF
-- require'nvim-treesitter.configs'.setup {
--   refactor = {
--     highlight_current_scope = { enable = true },
--   },
-- }
-- EOF

-- lua <<EOF
-- require'nvim-treesitter.configs'.setup {
--   refactor = {
--     smart_rename = {
--       enable = true,
--       keymaps = {
--         smart_rename = "grr",
--       },
--     },
--   },
-- }
-- EOF

-- lua <<EOF
-- require'nvim-treesitter.configs'.setup {
--   refactor = {
--     navigation = {
--       enable = true,
--       keymaps = {
--         goto_definition = "gnd",
--         list_definitions = "gnD",
--         list_definitions_toc = "gO",
--         goto_next_usage = "<a-*>",
--         goto_previous_usage = "<a-#>",
--       },
--     },
--   },
-- }
-- EOF

----------------------------
-- CMDS
----------------------------

-- tsp.cmds = {}

--------------------------
-- AUTOCMDS
--------------------------

-- tsp.autocmds = {}

----------------------------
-- BINDS
----------------------------

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

-- tsp.binds = {
--   "<leader>",
--   name = "+prefix",
--   {
--     {
--       "n",
--       name = "+test",
--       {
--         {
--           {
--             "t",
--             name = "+ts",
--             -- TSContextEnable, TSContextDisable and TSContextToggle.
--             { "c", [[ :TSContextToggle<cr> ]], name = "toggle context" },
--           },
--         },
--       },
--     },
--   },
-- }

----------------------------
-- RETURN
----------------------------

return tsp
