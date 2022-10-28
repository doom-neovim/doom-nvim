local M = {}

M.settings = {}

M.packages = {
  ["zen-mode.nvim"] = {
    "folke/zen-mode.nvim",
  },
  ["vimade"] = {
    "TaDaa/vimade",
  },
}

M.configs = {
  ["zen-mode.nvim"] = function()
    require("zen-mode").setup({
      window = {
        width = 180,
      },
    })
  end,
}

M.autocmds = {}

M.cmds = {}

M.binds = {
  {
    "<leader>v",
    name = "+views",
    { -- Adds a new `whichkey` folder called `+info`
      { "z", "<cmd>ZenMode<cr>", name = "Zen mode" },
    },
  },
}

return M
