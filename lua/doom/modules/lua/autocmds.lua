local autocmds = {
  {
    "BufNewFile,BufRead",
    "*.lua",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/lua/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
