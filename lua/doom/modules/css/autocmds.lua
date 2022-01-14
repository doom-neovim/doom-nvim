local autocmds = {
  {
    "BufNewFile,BufRead",
    "*.css,*.scss,*.vue",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/css/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
