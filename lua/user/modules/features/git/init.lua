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
  ["diffview.nvim"] = {
    "sindrets/diffview.nvim",
    requires = 'nvim-lua/plenary.nvim'
  },
  ["git-conflict.nvim"] = {
    "akinsho/git-conflict.nvim",
  },
  ["gitsigns.nvim"] = {
    "lewis6991/gitsigns.nvim",
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

  ["git-conflict.nvim"] = function()
    require('git-conflict').setup()
  end,
  ["gitsigns.nvim"] = function()
    require('gitsigns').setup()
  end,
}
M.autocmds = {
}

M.cmds = {
}

-- TODO: fix bug doom-nvim, so it can load if 'M.bind= {}'
M.binds = {
  {
    "]c",
    [[<cmd>Gitsigns next_hunk<CR>]],
    name = "Next hunk",
    mode = "n",
  },
  {
    "[c",
    [[<cmd>Gitsigns prev_hunk<CR>]],
    name = "Prev hunk",
    mode = "n",
  },
  {
    "<leader>g",
    -- name = "+git",
    {
      { "g", "<cmd>Neogit<CR>", name = "Neogit" },
      { "l", "<cmd>Telescope git_bcommits<CR>", name = "Current buffer logs" },
      { "L", "<cmd>Telescope git_commits<CR>", name = "Git Logs" },
    }
  },
} return M
