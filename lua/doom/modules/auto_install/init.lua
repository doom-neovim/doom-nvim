local auto_install = {}

auto_install.defaults = {
  lsp_dir = vim.fn.stdpath("data") .. "/lsp-install/",
  dap_dir = vim.fn.stdpath("data") .. "/dap-install/",
}

auto_install.packer_config = {}
auto_install.packer_config["nvim-lsp-installer"] = function()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.settings({
    install_root_dir = doom.auto_install.lsp_dir,
  })
end
auto_install.packer_config["DAPInstall.nvim"] = function()
  local dap_install = require("dap-install")
  dap_install.setup({
    installation_path = doom.auto_install.dap_dir,
  })
end

return auto_install
