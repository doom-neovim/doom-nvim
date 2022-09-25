local auto_install = {}

auto_install.settings = {
  lsp_dir = nil, -- Change to a custom path such as `vim.fn.stdpath("data") .. "/lsp-install"`
  dap_dir = nil, -- Change to a custom path such as `vim.fn.stdpath("data") .. "/dap-install"`
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
    commit = "ae913cb4fd62d7a84fb1582e11f2e15b4d597123",
    -- disabled = not is_module_enabled("features", "lsp"),
  },
  ["mason.nvim"] = {
    "williamboman/mason.nvim",
    commit = "75860d253f9e66d08c9289dc43fae790882eb136",
  },
  ["mason-lspconfig"] = {
    "williamboman/mason-lspconfig",
    commit = "b70dedab5ceb5f3f84c6bc9ceea013292a14f8dc",
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
auto_install.configs["mason.nvim"] = function()
  require("mason").setup()
end

return auto_install
