return {
  ["DAPInstall.nvim"] = {
    "Pocco81/DAPInstall.nvim",
    commit = "dd09e9dd3a6e29f02ac171515b8a089fb82bb425",
    after = "nvim-dap",
    cmd = {
      "DIInstall",
      "DIList",
      "DIUninstall",
    },
    module = "dap-install",
  },
  ["nvim-lsp-installer"] = {
    "williamboman/nvim-lsp-installer",
    commit = "bcce5db53b966e2dbd97fc8d1bbfa7db4a405f13",
    opt = true,
    module = "nvim-lsp-install",
  },
}
