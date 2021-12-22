return {
  ["nvim-dap"] = {
    "mfussenegger/nvim-dap",
    commit = "4e8bb7ca12dc8ca6f7a500cbb4ecea185665c7f1",
    module = "dap",
  },
  ["nvim-dap-ui"] = {
    "rcarriga/nvim-dap-ui",
    commit = "649e0fee4f0b8dc6305dd29065c7623c3dc6a032",
    after = { "nvim-dap", "nest.nvim" },
  },
}
