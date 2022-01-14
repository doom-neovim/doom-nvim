local autocmds = {
  {
    "BufNewFile,BufRead",
    "*.ts,*.vue",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/typescript/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
