-- Couple of mini plugin, most from https://github.com/echasnovski/mini.nvim

local M = {}

M.settings = {}

M.packages = {
  ["mini.nvim"] = {
    "echasnovski/mini.nvim",
  },
  -- ["vimade"] = {
  --   "TaDaa/vimade",
  -- },
}

M.configs = {
  ["mini.nvim"] = function()
    -- common sense setting
    -- require('mini.basics').setup()
    -- Go back/forward (f, F...) in also nextline. ";" supported
    require("mini.jump").setup()

    -- Actually it's same with HopChar. Will keep both for a while to see which one is better
    require("mini.jump2d").setup({
      mappings = {
        start_jumping = "<CR>",
      },
    })
    -- similar to vim-sandwich
    require("mini.surround").setup()

    -- use gcc to comment line
    require('mini.comment').setup()

    -- correct buffer to display when delete a buffer
    -- Not use, sometime bugs when press j/k
    -- require('mini.bufremove').setup()
    -- Hight light current indent level

    require('mini.indentscope').setup(
      {draw = {
        animation = require('mini.indentscope').gen_animation.none()
      }}
    )
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
