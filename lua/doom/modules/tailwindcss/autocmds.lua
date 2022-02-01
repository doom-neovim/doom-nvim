local autocmds = {
  {
    "BufNewFile,BufRead",
    "*.html,*.css,*.scss,*.vue",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/tailwindcss/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
