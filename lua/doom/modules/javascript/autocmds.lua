local autocmds = {
  {
    "BufNewFile,BufRead",
    "*.js",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/javascript/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
