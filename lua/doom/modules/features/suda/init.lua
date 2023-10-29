local suda = {}

suda.settings = {}

suda.packages = {
  ["suda.vim"] = {
    "lambdalisue/suda.vim",
    lazy = true,
    cmd = { "SudaRead", "SudaWrite" },
  },
}

suda.configs = {}

suda.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "f",
      name = "+file",
      {
        { "R", "<cmd>SudaRead<CR>", name = "Read with sudo" },
        { "W", "<cmd>SudaWrite<CR>", name = "Write with sudo" },
      },
    },
  },
}

return suda
