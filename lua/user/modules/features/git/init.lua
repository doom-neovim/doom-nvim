local M = {}

M.settings = {
}

M.packages = {
  ["neogit"] = {
    "TimUntersberger/neogit",
  },
  ["git-blame.nvim"] = {
    "f-person/git-blame.nvim",
  },
  -- TODO: apply diff view on git
  ["diffview.nvim"] = {
    "sindrets/diffview.nvim",
    requires = 'nvim-lua/plenary.nvim'
  },

}

M.configs = {
  ["neogit"] = function()
    require("neogit").setup({
      integrations = {
        diffview = true
      },
    })
  end,

}

M.autocmds = {
}

M.cmds = {
}

-- TODO: fix bug doom-nvim, so it can load if 'M.bind= {}'
-- M.binds =
-- {
--   -- {
--   --   "ghw",
--   --   [[<cmd>HopWord<CR>]],
--   --   name = "Go to word in the screen",
--   --   mode = "nv",
--   -- },
-- }

return M
