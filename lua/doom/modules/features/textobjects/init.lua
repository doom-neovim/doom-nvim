local textobjects = {}

textobjects.packages = {
  ["nvim-treesitter-textobjects"] = { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- ["nvim-treesitter-textsubjects"] = { "RRethy/nvim-treesitter-textsubjects", }
  -- ["treesitter-unit"] = {"David-Kunz/treesitter-unit"},
  -- ["hatchet.nvim"] = {"zacharydscott/hatchet.nvim"},
}

textobjects.configs = {}

textobjects.configs = function()
  -- lua <<EOF
  -- require'nvim-treesitter.configs'.setup {
  --   textobjects = {
  --     select = {
  --       enable = true,
  --       -- Automatically jump forward to textobj, similar to targets.vim
  --       lookahead = true,
  --       keymaps = {
  --         -- You can use the capture groups defined in textobjects.scm
  --         ["af"] = "@function.outer",
  --         ["if"] = "@function.inner",
  --         ["ac"] = "@class.outer",
  --         ["ic"] = "@class.inner",
  --       },
  --     },
  --   },
  -- }
  -- EOF

  -- lua <<EOF
  -- require'nvim-treesitter.configs'.setup {
  --   textobjects = {
  --     swap = {
  --       enable = true,
  --       swap_next = {
  --         ["<leader>a"] = "@parameter.inner",
  --       },
  --       swap_previous = {
  --         ["<leader>A"] = "@parameter.inner",
  --       },
  --     },
  --   },
  -- }
  -- EOF

  -- lua <<EOF
  -- require'nvim-treesitter.configs'.setup {
  --   textobjects = {
  --     move = {
  --       enable = true,
  --       set_jumps = true, -- whether to set jumps in the jumplist
  --       goto_next_start = {
  --         ["]m"] = "@function.outer",
  --         ["]]"] = "@class.outer",
  --       },
  --       goto_next_end = {
  --         ["]M"] = "@function.outer",
  --         ["]["] = "@class.outer",
  --       },
  --       goto_previous_start = {
  --         ["[m"] = "@function.outer",
  --         ["[["] = "@class.outer",
  --       },
  --       goto_previous_end = {
  --         ["[M"] = "@function.outer",
  --         ["[]"] = "@class.outer",
  --       },
  --     },
  --   },
  -- }
  -- EOF

  -- lua <<EOF
  -- require'nvim-treesitter.configs'.setup {
  --   textobjects = {
  --     lsp_interop = {
  --       enable = true,
  --       border = 'none',
  --       peek_definition_code = {
  --         ["<leader>df"] = "@function.outer",
  --         ["<leader>dF"] = "@class.outer",
  --       },
  --     },
  --   },
  -- }
  -- EOF
end

-- textobjects.configs["nvim-treesitter-textsubjects"] = function()
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



textobjects.binds = {}

-- textobjects.binds = {
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
--             { "c", [[ :TSContextToggle<cr> ]], name = "toggle context" },
--           },
--         },
--       },
--     },
--   },
-- }

return textobjects
