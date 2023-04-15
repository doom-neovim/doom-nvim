local gitsigns = {}

gitsigns.settings = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "│",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "│",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "_",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

  },
  watch_gitdir = { interval = 1000, follow_files = true },
  current_line_blame_opts = {
    delay = 1000,
    position = "eol",
  },
  sign_priority = 6,
  update_debounce = 100,
  diff_opts = {
    internal = true, -- If luajit is present
  },
}

gitsigns.packages = {
  ["gitsigns.nvim"] = {
    "lewis6991/gitsigns.nvim",
    commit = "addd6e174a85fc1c4007ab0b65d77e6555b417bf",
    event = "VeryLazy",
  },
}

gitsigns.configs = {}
gitsigns.configs["gitsigns.nvim"] = function()
  require("gitsigns").setup(doom.features.gitsigns.settings)
end

gitsigns.binds = {
  {
    "<leader>g",
    name = "+git",
    {
      {
        "s",
        "<cmd>lua require'gitsigns'.stage_hunk()<CR>",
        name = " Stage Hunk",
      },
      {
        "u",
        "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>",
        name = " Unstage Hunk",
      },
      {
        "R",
        "<cmd>lua require'gitsigns'.reset_hunk()<CR>",
        name = " Reset Hunk",
      },
      {
        "n",
        "<cmd>lua require'gitsigns'.next_hunk()<CR>",
        name = "Next Hunk",
      },
      {
        "p",
        "<cmd>lua require'gitsigns'.prev_hunk()<CR>",
        name = "Prev Hunk",
      },
      {
        "b",
        "<cmd>lua require'gitsigns'.blame_line()<CR>",
        name = "Blame Line",
      },
      {
        "h",
        "<cmd>lua require'gitsigns'.preview_hunk()<CR>",
        name = " Preview Hunk",
      },
    },
  },
}

return gitsigns
