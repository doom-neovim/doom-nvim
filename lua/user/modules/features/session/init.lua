local M = {}

M.settings = {}

M.packages = {
  ["telescope_sessions_picker"] = {
    "JoseConseco/telescope_sessions_picker.nvim",
    after = "telescope.nvim",
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}

M.configs = {
  ["telescope_sessions_picker"] = function()
    require("telescope").load_extension("sessions_picker")
    require("mini.sessions").setup({
      autoread = true,
      autowrite = true,
      file = "Session.vim",
      directory = vim.fn.stdpath("data") .. "/sessions/",
    })
  end,
}

M.autocmds = {}

M.cmds = {}
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
