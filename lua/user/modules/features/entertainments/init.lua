-- Module to put some entertainment facilitate
-- - Spotify control
--    evaluated:
--    -  KadoBOT/nvim-spotify(require spotify-tui) => not satisfy
--    -  "stsewd/spotify.nvim" requires wmctl and pydbus,

--
local M = {}

M.settings = {}

M.packages = {
  ["spotify"] = {
    "stsewd/spotify.nvim",
  },
}

M.configs = {
  -- ["nvim-spotifi"] = function()
  --   local spotify = require("nvim-spotify")
  --
  --   spotify.setup({
  --     -- default opts
  --     status = {
  --       update_interval = 10000, -- the interval (ms) to check for what's currently playing
  --       format = "%s %t by %a", -- spotify-tui --format argument
  --     },
  --   })
  -- end,
}

M.autocmds = {}

M.cmds = {}
-- M.requires_modules = { "features.auto_install" }
M.binds =
{
  {
    "<leader>E",
    name = "Entertainment",
    mode = "nv",
    {
      {'n' ,  ":Spotify next<cr>", "SpotNext" },
      {'p' ,  ":Spotify prev<cr>", "SpotPrev" },
      {'s' ,  ":Spotify play/pause<cr>", "SpotPlay/Stop" },
      {'S' ,  ":Spotify show<cr>", "SpotShow" },
      {'u' ,  ":Spotify status<cr>", "SpotStatus" },

    }
  },
}

-- Notes:
-- code for load module located at doom.core.module.load_modules
-- code for binding: ddom.services.keymaps.applyKeymaps
return M
