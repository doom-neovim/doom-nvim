local M = {}

M.settings = {}

M.packages = {
  ["zen-mode.nvim"] = {
    "folke/zen-mode.nvim",
  },
  ["vimade"] = {  -- fade unfocused buffer
    "TaDaa/vimade",
  },
  ["nvim-treesitter-context"] = {  -- stick current context (class/function when scroll)
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

        print ("windows is ", windows)
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
    "BDthis",
    function()
      vim.cmd("BDelete this") -- BDelete this
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
    "BDOther",
    function()
      -- vim.cmd("%bdelete")
      vim.cmd("BDelete other")
    end,
  },
  {
    "BDAll",
    function()
      -- vim.cmd("%bdelete")
      vim.cmd("BDelete all")
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
    },
  },
  {
    "<leader>w",
    -- name = "+views",
    { -- Adds a new `whichkey` folder called `+info`
      { "x", "<cmd>BDthis<cr>", name = "Close" },
    },
  },
}

return M
