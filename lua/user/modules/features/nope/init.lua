-- This is DO-NOTHING load_modules
-- FOr testing api of doom-nvim only purpose
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
M.binds = {
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
