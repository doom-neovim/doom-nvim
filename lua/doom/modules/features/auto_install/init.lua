local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.auto_install
---@text # Auto install (LSP/null-ls)
---
--- This module adds the ability to auto install lsps/null-ls providers when
--- enabling language modules using `mason.nvim`.  It will not try to keep the
--- LSP providers or null-ls sources up to date.  Sometimes plugins or doom-nvim
--- may update and you will have to manually update the packages yourself using
--- the `:Mason[Install|Uninstall] <package_name>` command.
---
--- ## Deleting all mason.nvim packages
--- You can delete all mason nvim packages by running the command `:DoomNuke mason`

local auto_install = DoomModule.new("auto_install")

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.auto_install")
auto_install.settings = {
  lsp = {
    --- List of lsp providers to automatically install and setup
    ensure_installed = {},
    --- Whether or not to automatically install the lsp providers in ensure_installed
    automatic_installation = true,
  },
}
---minidoc_afterlines_end

---@eval return doom.core.doc_gen.generate_packages_documentation("features.auto_install")
auto_install.packages = {
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
auto_install.configs["mason.nvim"] = function()
  require("mason").setup()
end

---@eval return doom.core.doc_gen.generate_commands_documentation("features.auto_install")
auto_install.cmds = {
  -- We can't lazy load mason-lspconfig through packer because some helper
  -- functions in lua/modules/langs/utils.lua require access to the plugin
  -- (requires the lsp<->mason packagelookup table).  This lets us load the rest
  -- of mason-lspconfig when the user tries to install something.
  {
    "LspInstall",
    function(opts)
      vim.cmd("packadd mason-lspconfig")
      vim.cmd("lua require('mason-lspconfig').setup(doom.features.auto_install.settings.lsp)")
      vim.cmd("LspInstall " .. opts.args)
    end,
    description = "Install an LSP",
  },
  {
    "LspUninstall",
    function(opts)
      vim.cmd("packadd mason-lspconfig")
      vim.cmd("lua require('mason-lspconfig').setup(doom.features.auto_install.settings.lsp)")
      vim.cmd("LspInstall " .. opts.args)
    end,
    description = "Uninstall an LSP",
  },
}

return auto_install
