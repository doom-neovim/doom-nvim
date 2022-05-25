local latex = {}

latex.settings = {}

-- https://github.com/search?q=vim+latex

latex.packages = {
  ["nabla.nvim"] = { "jbyuki/nabla.nvim" }, -- , config = require("molleweide.configs.nabla")
  -- https://github.com/lervag/vimtex
  -- https://github.com/gerw/vim-latex-suite
}

-- return function()
--
--   -- vim.cmd([[ autocmd BufEnter github.com_*.txt set filetype=markdown ]])
--   --
--   vim.cmd[[ nnoremap <F5> :lua require("nabla").action()<CR> ]]
--   vim.cmd[[ nnoremap <leader>Tp :lua require("nabla").popup()<CR> ]] -- Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
--
--   local mappings = require("doom.utils.mappings")
--
--   -- require("nabla").popup({ border = "rounded" })
--
--   -- mappings.imap("<Tab>", on_tab, { expr = true })
--
--   -- mappings.map(
--   --   "n",
--   --   "<F8>",
--   --   "<cmd>lua require("nabla").action()<CR>",
--   --   { noremap = true },
--   --   "Editor",
--   --   "nabla_enable",
--   --   "Nabla Enable"
--   -- )
--
--   -- mappings.map(
--   --   "n",
--   --   "<leader>N",
--   --   '<cmd>lua require("nabla").popup()<CR>',
--   --   { noremap = true },
--   --   "Editor", -- ??
--   --   "nabla_popup",
--   --   "Nabla Popup",
--   -- )
--
-- end


return latex
