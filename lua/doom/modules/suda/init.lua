local suda = {}

suda.defaults = {}

suda.packages = {
  ["suda.vim"] = {
    "lambdalisue/suda.vim",
    commit = "0290c93c148a14eab2b661a1933003d86436f6ec",
    opt = true,
    cmd = { "SudaRead", "SudaWrite" },
  },
}

suda.configure_functions = {}

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
