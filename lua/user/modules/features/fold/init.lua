local M = {}

M.settings = {
  foldcolumn = "1", -- '0' is not bad
  foldlevel = 2, -- Using ufo provider need a large value, feel free to decrease the value
  foldlevelstart = 2,
  foldenable = true,
}

M.packages = {
  ["nvim-ufo"] = {
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
  },
}

M.configs = {
  ["nvim-ufo"] = function()
    local settings = doom.features.fold.settings

    vim.o.foldcolumn = settings.foldcolumn
    vim.o.foldlevel = settings.foldlevel
    vim.o.foldlevelstart = settings.foldlevelstart
    vim.o.foldenable = settings.foldenable

    -- use tree-sitter as the fold client TODO: try to use LSP
    --
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,

      -- TODO: Need to check why preview doesnot work
      preview = {
        mappings = {
          scrollB = "h",
          scrollF = "l",
          scrollU = "k",
          scrollD = "j",
          scrollE = "<C-E>",
          scrollY = "<C-Y>",
          close = "q",
          switch = "<C-Tab>",
          trace = "<CR>",
        },
        win_config = {
          maxheight = 60,
        },
      },
    })

    -- require("ufo").setup({
    --   provider_selector = function(bufnr, filetype, buftype)
    --     return ""
    --   end,
    -- })
  end,
}

M.autocmds = {}

M.cmds = {
  {
    "FoldL",
    function(opts)
      local foldlvel = opts.args
      -- vim.cmd("set foldlevelstart="..foldlvel) -- BDelete this
      vim.cmd("set foldlevel="..foldlvel) -- BDelete this
      -- vim.cmd(".,$-bdelete")
      -- require('close_buffers').delete({ type = 'other' })
    end,
    { nargs = "*" },
  },
  {
    "Fold",
    function(opts)
      local foldlvel = opts.args
      vim.cmd("set foldlevelstart="..foldlvel) -- BDelete this
      vim.cmd("set foldlevel="..foldlvel) -- BDelete this
      -- vim.cmd(".,$-bdelete")
      -- require('close_buffers').delete({ type = 'other' })
    end,
    { nargs = "*" },
  },
}

M.binds = {
  {
    "zv",
    [[<cmd>lua require('ufo.preview'):peekFoldedLinesUnderCursor(true, false) <CR>]],
    name = "Fold preview",
    mode = "nv",
  },
  {
    "z1",
    [[<cmd>set foldlevel=1<CR>]],
    name = "Fold level 1",
    mode = "nv",
  },
  { "z2", [[<cmd>set foldlevel=2<CR>]], name = "Fold level 2", mode = "nv" },
  { "z9", [[<cmd>set foldlevel=9<CR>]], name = "Fold level 9", mode = "nv" },
  {
    "z+",
    [[<cmd>let &foldlevel=&foldlevel + 1<CR>]],
    name = "Increase fold level",
    mode = "nv",
  },
  {
    "z-",
    [[<cmd>let &foldlevel=&foldlevel - 1<CR>]],
    name = "Increase fold level",
    mode = "nv",
  },
}

return M
