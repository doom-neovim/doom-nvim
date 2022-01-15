local is_plugin_disabled = require("doom.utils").is_plugin_disabled

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
    disabled = is_plugin_disabled("dap"),
    module = "dap-install",
  },
  ["nvim-lsp-installer"] = {
    "williamboman/nvim-lsp-installer",
    commit = "7a4f43beaf579f48b190e4a0784d4b3317157495",
    opt = true,
    disabled = is_plugin_disabled("lsp"),
    module = "nvim-lsp-install",
  },
}
