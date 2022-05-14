-- https://github.com/rockerBOO/awesome-neovim#formatting
local formatting = {}

formatting.settings = {}

formatting.packages = {
  ["vim-stripper"] = { "itspriddle/vim-stripper" }, -- strip whitespace on save
  -- https://github.com/AckslD/nvim-trevJ.lua
  -- https://github.com/mhartington/formatter.nvim
}

------------------------------
---       formatting       ---
------------------------------

-- { "n", "<leader>ai", "mzgg=G`z<cr>", opts.s, "Format", "indent_file", "Indent File" },
-- { "n", "<leader>au", "viwUe", opts.s, "Format", "upper_case", "Word Upper" },
-- { "n", "<leader>aU", "viwue", opts.s, "Format", "lower_case", "Word Lower" },

-- linter.binds = {
--   {
--     "<leader>cf",
--     function()
--       vim.lsp.buf.formatting_sync()
--     end,
--     name = "Format/Fix",
--   },
-- }

return formatting
