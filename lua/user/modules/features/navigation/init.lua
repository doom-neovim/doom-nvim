local M = {}

M.settings = {}

M.packages = {
  -- ["noice.nvim"] = {
  --   "folke/noice.nvim",
  --   requires = "MunifTanjim/nui.nvim",
  -- },
  ["vim-sandwich"] = {
    "machakann/vim-sandwich",
  },
  ["symbols-outline.nvim"] = { "simrat39/symbols-outline.nvim", },

  ["cutlass.nvim"] = {
    "tuanbass/cutlass.nvim", },
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
  ["vim-matchup"] = { -- smart open/close match navigation
    "andymass/vim-matchup",
  },
  ["delaytrain.nvim"] = { -- penalty when repeat j/k for navigation
    "ja-ford/delaytrain.nvim",
  },
  ["better-escape.nvim"] = { -- penalty when repeat j/k for navigation
    "max397574/better-escape.nvim",
  },
}

M.configs = {
  -- ["noice.nvim"] = function()
  --   require("noice").setup()
  -- end,

  ["cutlass.nvim"] = function()
    -- vim.notify("Setting up cutlass plugin", "info")
    require("cutlass").setup({
      cut_key = "m",
    })
  end,
  ["better-escape.nvim"] = function()
      require("better_escape").setup({
        mapping = {"jk", "jj", "kj", "kk"}, -- a table with mappings to use
        keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
      })

  end,

  ["hop.nvim"] = function()
    -- vim.notify("Setting up cutlass plugin", "info")
    require("hop").setup()
  end,
  ["vim-expand-region"] = function()
    vim.g.expand_region_text_objects = {
      ["i"] = 0,
      ["iw"] = 0,
      ["i]"] = 1,
      ["i}"] = 1,
      ["i)"] = 1,
      ["it"] = 1,
      ["ib"] = 1,
      ["iB"] = 1,
      ["il"] = 0,
      ["ip"] = 0,
      ["ie"] = 0,
    }

    -- TODO: convert to use module binding mechanism
    vim.cmd([[
          vmap v <Plug>(expand_region_expand)
    ]])
  end,
  ["symbols-outline.nvim"] = function()
    -- vim.notify("Setting up cutlass plugin", "info")
    require("symbols-outline").setup()
  end,
  ["vim-matchup"] = function()
     vim.g.matchup_matchparen_offscreen = {}
  end,
  ["delaytrain.nvim"] = function()
      require('delaytrain').setup {
          delay_ms = 500,  -- How long repeated usage of a key should be prevented
          grace_period = 3, -- How many repeated keypresses are allowed
          keys = {          -- Which keys (in which modes) should be delayed
              ['n'] = {'h', 'j', 'k', 'l'},
              -- ['nvi'] = {'<Left>', '<Down>', '<Up>', '<Right>'},
          },
      }
    -- vim.notify("Setting up cutlass plugin", "info")
  end,

}

M.autocmds = {}

M.cmds = {}

M.binds = {

  {
    -- Hop char
    "<C-G>",
    [[<cmd>HopChar1<CR>]],
    name = "Go to anychar in the screen",
    mode = "inv",
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
  {
    "<C-g>w",
    [[<cmd>HopWord<CR>]],
    name = "Go to word in the screen",
    mode = "nv",
  },

  -- -- Expand region
  -- {
  --   "v",
  --   [[<Plug>(expand_region_expand)]],
  --   name = "Expand selection",
  --   mode = "nv",
  -- },
}

return M
