-- Unintegrated packages
-- Spotify
-- goto-preview
-- NeoRoot
-- ThePrimeagen/refactoring.nvim
-- ray-x/lsp_signature.nvim
-- ray-x/lsp_signature.nvim
-- rcarriga/nvim-dap-ui
-- theHamsta/nvim-dap-virtual-text
-- nvim-telescope/telescope-dap.nvim
-- gcmt/taboo.vim
-- pretty-fold
-- fold-preview
-- preservim/vim-markdown
-- godlygeek/tabular
-- iamcco/markdown-preview.nvim
-- SidOfc/mkdx
-- nvim-orgmode/orgmode
-- ekickx/clipboard-image.nvim
local M = {}

M.settings = {
}

M.packages = {
  -- ["zen-mode.nvim"] = {
  --   "folke/zen-mode.nvim",
  -- },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },

}

M.configs = {
  -- ["zen-mode.nvim"] = function()
  --       require("zen-mode").setup {
  --         window = {
  --           width = 180,
  --         }
  --       }
  -- end,

}

M.autocmds = {
}

M.cmds = {
}
-- M.requires_modules = { "features.auto_install" }
-- M.binds kk
-- {
--   -- {
--   --   "ghw",
--   --   [[<cmd>HopWord<CR>]],
--   --   name = "Go to word in the screen",
--   --   mode = "nv",
--   -- },
-- }

-- Notes:
-- code for load module located at doom.core.module.load_modules
-- code for binding: ddom.services.keymaps.applyKeymaps
return M
