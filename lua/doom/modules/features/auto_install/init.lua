local auto_install = {}

auto_install.settings = {
  lsp_dir = vim.fn.stdpath("data") .. "/lsp-install",
  dap_dir = vim.fn.stdpath("data") .. "/dap-install",
}

local is_plugin_disabled = require("doom.utils").is_plugin_disabled

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
    disabled = is_plugin_disabled("dap"),
    module = "dap-install",
    disable = true,
  },
  ["nvim-lsp-installer"] = {
    "williamboman/nvim-lsp-installer",
    commit = "29154c2fe1147c8eed5d54a419841e5637a8c3b2",
    opt = true,
    disabled = is_plugin_disabled("lsp"),
    module = "nvim-lsp-install",
  },
}

auto_install.configure_functions = {}
auto_install.configure_functions["nvim-lsp-installer"] = function()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.settings({
    install_root_dir = doom.modules.auto_install.settings.lsp_dir,
  })
end
auto_install.configure_functions["DAPInstall.nvim"] = function()
  local dap_install = require("dap-install")
  dap_install.setup({
    installation_path = doom.modules.auto_install.settings.dap_dir,
  })
end

return auto_install
