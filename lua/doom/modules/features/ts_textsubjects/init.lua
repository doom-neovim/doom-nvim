local ts_tsub = {}

ts_tsub.packages = {
  ["nvim-treesitter-textsubjects"] = {
    "RRethy/nvim-treesitter-textsubjects",
    requires = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    opt = true,
  }
}

ts_tsub.configs = {}

-- ts_tsub.configs["nvim-treesitter-textsubjects"] = function()
--   require('nvim-treesitter.configs').setup {
--       textsubjects = {
--           enable = true,
--           prev_selection = ',', -- (Optional) keymap to select the previous selection
--           keymaps = {
--               ['.'] = 'textsubjects-smart',
--               [';'] = 'textsubjects-container-outer',
--               ['i;'] = 'textsubjects-container-inner',
--           },
--       },
--   }
-- end

-- ts_tsub.binds = {
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

return ts_tsub
