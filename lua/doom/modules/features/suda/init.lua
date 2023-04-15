local suda = {}

suda.settings = {}

suda.packages = {
  ["suda.vim"] = {
    "lambdalisue/suda.vim",
    commit = "08abd39dfe1cee681b8ce3e7321da5fa03e045c1",
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
