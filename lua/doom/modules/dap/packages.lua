return {
  ["nvim-dap"] = {
    "mfussenegger/nvim-dap",
    commit = "c9a58267524f560112ecb6faa36ab2b5bc2f78a3",
    module = "dap",
  },
  ["nvim-dap-ui"] = {
    "rcarriga/nvim-dap-ui",
    commit = "ae3b003af6c6646832dfe704a1137fd9110ab064",
    after = { "nvim-dap", "nest.nvim" },
  },
}
