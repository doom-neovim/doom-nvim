local is_plugin_disabled = require("doom.utils").is_plugin_disabled

return {
  ["DAPInstall.nvim"] = {
    "Pocco81/DAPInstall.nvim",
    commit = "24923c3819a450a772bb8f675926d530e829665f",
    -- after = "nvim-dap",
    cmd = {
      "DIInstall",
      "DIList",
      "DIUninstall",
    },
    disabled = is_plugin_disabled("dap"),
    module = "dap-install",
    disable = true,
  },
  ["nvim-lsp-installer"] = {
    "williamboman/nvim-lsp-installer",
    commit = "8649d9ce34e796da27fcb7bb84249375e69d34d5",
    opt = true,
    disabled = is_plugin_disabled("lsp"),
    module = "nvim-lsp-install",
  },
}
