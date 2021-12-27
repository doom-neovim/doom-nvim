local autocmds = {
  { "BufNewFile,BufRead", "*.lua", "++once", [[lua dofile(vim.api.nvim_get_runtime_file("*/doom/modules/lua/config.lua", false)[1])]] }
}

return autocmds
