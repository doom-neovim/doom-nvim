local suda = {}

suda.settings = {}

suda.packages = {
  ["suda.vim"] = {
    "lambdalisue/suda.vim",
    commit = "6bffe36862faa601d2de7e54f6e85c1435e832d0",
    opt = true,
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
