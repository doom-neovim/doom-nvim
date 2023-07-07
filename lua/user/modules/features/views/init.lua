local M = {}

M.settings = {}

M.packages = {
  ["zen-mode.nvim"] = {
    "folke/zen-mode.nvim",
  },
  ["vimade"] = { -- fade unfocused buffer
    "TaDaa/vimade",
  },
  ["nvim-treesitter-context"] = { -- stick current context (class/function when scroll)
    "nvim-treesitter/nvim-treesitter-context",
  },
  ["vim-scratchpad"] = { -- type "dsp in edit buffer" to edit misc
    "konfekt/vim-scratchpad",
  },
  ["quick-scope"] = { -- highlight char to go left/righ
    "unblevable/quick-scope",
  },
  ["close-buffers.nvim"] = { -- highlight char to go left/righ
    "kazhala/close-buffers.nvim",
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
  ["close-buffers.nvim"] = function()
    require("close_buffers").setup({
      preserve_window_layout = { "this", "other", "all" },
      next_buffer_cmd = function(windows)
        require("bufferline").cycle(1)
        local bufnr = vim.api.nvim_get_current_buf()

        for _, window in ipairs(windows) do
          vim.api.nvim_win_set_buf(window, bufnr)
        end
      end,
    })
  end,
}

M.autocmds = {}

M.cmds = {
  -- command! BufferKillForce lua require('lvim.core.bufferline').buf_kill('bd', nil, true)
  {
    "BD1this",
    function()
      vim.cmd("BDelete this") -- BDelete this
      -- vim.cmd(".,$-bdelete")
      -- require('close_buffers').delete({ type = 'other' })
    end,
  },
  {
    "BDReopen",
    function()
      vim.cmd("BDelete this") -- BDelete this
      vim.cmd("edit #") -- reopen last file
      -- vim.cmd(".,$-bdelete")
      -- require('close_buffers').delete({ type = 'other' })
    end,
  },
  {
    "BDthisForce",
    function()
      vim.cmd("BDelete! this")
      -- vim.cmd(".,$-bdelete")
      -- require('close_buffers').delete({ type = 'other' })
    end,
  },
  {
    "BD2Other",
    function()
      -- vim.cmd("%bdelete")
      vim.cmd("BufferLineCloseLeft")
      vim.cmd("BufferLineCloseRight")
    end,
  },
  {
    "BD3All",
    function()
      -- vim.cmd("%bdelete")
      vim.cmd("BD2Other")
      vim.cmd("BD1this")
    end,
  },

  {
    "ToggleScratchPad",
    function()
      -- vim.cmd("%bdelete")
      vim.cmd("echo 'type dsp in normal mode to toggle Scratpad'")
    end,
  },
}

M.binds = {
  {
    "<leader>v",
    name = "+views",
    { -- Adds a new `whichkey` folder called `+info`
      { "z", "<cmd>ZenMode<cr>", name = "Zen mode" },
      { "s", "<cmd>SymbolsOutline<cr>", name = "SymbolsOutline" },

      {
        't',
        {
          { "z", "<cmd>Trouble document_diagnostics<cr>", name = "Troule this buf" },
          { "a", "<cmd>Trouble workspace_diagnostics<cr>", name = "Troule all " },
        },
          name = "+Trouble",

      },
    },
  },
  {
    "<leader>w",
    -- name = "+views",
    { -- Adds a new `whichkey` folder called `+info`
      { "x", "<cmd>BD1this<cr>", name = "Close" },
    },
  },
}

-- selective highlight group to fix the issue: when open a new buffer, cursorline in old buf are faded and difficult to read
vim.g.vimade = {
  basegroups = {
    -- "Folded",
    -- "Search",
    -- "SignColumn",
    -- -- "LineNr",
    -- -- "CursorLine",
    -- -- "CursorLineNr",
    -- "DiffAdd",
    -- "DiffChange",
    -- "DiffDelete",
    -- "DiffText",
    -- "FoldColumn",
    -- "Whitespace",
    -- "NonText",
    -- "SpecialKey",
    -- "Conceal",
    -- "EndOfBuffer",
  },
}
return M
