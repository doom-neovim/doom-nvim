local M = {}

M.settings = {
}

M.packages = {
  -- ["noice.nvim"] = {
  --   "folke/noice.nvim",
  --   requires = "MunifTanjim/nui.nvim",
  -- },
  ["vim-sandwich"] = {
    "machakann/vim-sandwich",
  },
  ["symbols-outline.nvim"] = {
    "simrat39/symbols-outline.nvim"
  },

  ["cutlass.nvim"] = {
    "tuanbass/cutlass.nvim",
  },
  ["textobj1"] = {
    "kana/vim-textobj-line",
  },
  ["textobj2"] = {
    "kana/vim-textobj-entire",
  },
  ["vim-expand-region"] = {
    "terryma/vim-expand-region",
  },
  ["textobj3"] = {
    "kana/vim-textobj-user",
  },
  ["hop.nvim"] = {
    "phaazon/hop.nvim", -- jum to anywhere in screen
  },
  ["quick-scope"] = { -- highlight char to go left/righ
    "unblevable/quick-scope",
  },

}

M.configs = {
  -- ["noice.nvim"] = function()
  --   require("noice").setup()
  -- end,

  ["cutlass.nvim"] = function ()
    -- vim.notify("Setting up cutlass plugin", "info")
    require("cutlass").setup({
        cut_key = "m"
    })
  end,

  ["hop.nvim"] = function ()
    -- vim.notify("Setting up cutlass plugin", "info")
    require("hop").setup()
  end,
  ["symbols-outline.nvim"] = function ()
    -- vim.notify("Setting up cutlass plugin", "info")
    require("symbols-outline").setup()
  end,
}

M.autocmds = {
}

M.cmds = {
}

M.binds =
{
  {
    "C-g",
    [[<cmd>HopChar1<CR>]],
    name = "Go to anychar in the screen",
    mode = "nv",
  },
  {
    "ghc",
    [[<cmd>HopChar1<CR>]],
    name = "Go to anychar in the screen",
    mode = "nv",
  },
  {
    "ghw",
    [[<cmd>HopWord<CR>]],
    name = "Go to word in the screen",
    mode = "nv",
  },
}

return M
