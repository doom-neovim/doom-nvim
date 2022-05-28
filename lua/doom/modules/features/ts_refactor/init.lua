local ts_refactor = {}

ts_refactor.packages = {
  ["nvim-treesitter-refactor"] = { "nvim-treesitter/nvim-treesitter-refactor" },
}

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

tsctx.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "n",
      name = "+test",
      {
        {
          {
            "t",
            name = "+ts",
            -- TSContextEnable, TSContextDisable and TSContextToggle.
            { "c", [[ :TSContextToggle<cr> ]], name = "toggle context" },
          },
        },
      },
    },
  },
}

return ts_refactor
