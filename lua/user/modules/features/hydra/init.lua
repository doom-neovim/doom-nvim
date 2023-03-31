local M = {}

M.settings = {}

M.packages = {
  ["hydra.nvim"] = {
    "anuvyklack/hydra.nvim",
    requires = "anuvyklack/keymap-layer.nvim",
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}
M.configs = {
  ["hydra.nvim"] = function()
    -- require("hydra").setup()
    local this = require('user.modules.features.hydra')
    this.window_hydra()

  end,
}

M.autocmds = {}

-- M.cmds = {
--   {
--     "TestHydra",
--     function()
--       require('user.modules.features.hydra').window_hydra()
--       -- vim.cmd(".,$-bdelete")
--       -- require('close_buffers').delete({ type = 'other' })
--     end,
--   },
-- }
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
M.window_hydra = function()
  local Hydra = require("hydra")
  print("window_hydra")
  Hydra({
    name = "Windows",
    mode = "n",
    body = "<C-a>",
    heads = {
      { "+", "<C-w>+" },
      { "-", "<C-w>-" , { desc = "height" }},

      { "<", "<C-w><" },
      { ">", "<C-w>>" , { desc = "width" }},

      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" , { desc = "l/d/u/r" }},

    },
  })

end
-- M.scroll_hydra = function()
--   local Hydra = require("hydra")
--   Hydra({
--     name = "Side scroll",
--     mode = "n",
--     body = "z",
--     heads = {
--       { "h", "5zh" },
--       { "l", "5zl", { desc = "←/→" } },
--       { "H", "zH" },
--       { "L", "zL", { desc = "half screen ←/→" } },
--     },
--   })
-- end
return M
