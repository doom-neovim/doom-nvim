local autocmds = {
  {
    "FileType",
    "rust",
    function()
      dofile(vim.api.nvim_get_runtime_file("*/doom/modules/rust/config.lua", false)[1])
    end,
    once = true,
  },
}

return autocmds
