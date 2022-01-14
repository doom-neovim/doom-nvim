local autocmds = {
  {
    "BufNewFile,BufRead",
    "*.vue",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/vue/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
