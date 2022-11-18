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

M.cmds = {}

M.binds = {
  {
    "zv",
    [[<cmd>lua require('ufo.preview'):peekFoldedLinesUnderCursor(true, false) <CR>]],
    name = "Fold preview",
    mode = "nv",
  },
}

return M
