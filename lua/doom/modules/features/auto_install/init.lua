local auto_install = {}

auto_install.settings = {
  lsp_dir = vim.fn.stdpath("data") .. "/lsp-install",
  dap_dir = vim.fn.stdpath("data") .. "/dap-install",
}

local is_module_enabled = require("doom.utils").is_module_enabled

auto_install.packages = {
  ["DAPInstall.nvim"] = {
    "Pocco81/DAPInstall.nvim",
    commit = "24923c3819a450a772bb8f675926d530e829665f",
    -- after = "nvim-dap",
    cmd = {
      "DIInstall",
      "DIList",
      "DIUninstall",
    },
    disabled = not is_module_enabled("features", "dap"),
    module = "dap-install",
    disable = true,
  },
  ["nvim-lsp-installer"] = {
    "williamboman/nvim-lsp-installer",
    commit = "b8c168ccb30529a11404e5f71525502ec6288ccf",
    -- disabled = not is_module_enabled("features", "lsp"),
  },
}

auto_install.configs = {}
auto_install.configs["nvim-lsp-installer"] = function()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.settings({
    install_root_dir = doom.features.auto_install.settings.lsp_dir,
  })
end
auto_install.configs["DAPInstall.nvim"] = function()
  local dap_install = require("dap-install")
  dap_install.setup({
    installation_path = doom.features.auto_install.settings.dap_dir,
  })
end

return auto_install
