--- Auto installer module
--- Most logic for this module is inside of `lua/doom/modules/langs/utils`
local auto_install = {}

auto_install.settings = {
  --- Settings for mason-lspconfig
  lsp = {
    --- List of lsp providers to automatically install and setup
    ensure_installed = {},
    --- Whether or not to automatically install the lsp providers in ensure_installed
    automatic_installation = true,
  },
}

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
  },
  {
    "LspUninstall",
    function(opts)
      vim.cmd("packadd mason-lspconfig")
      vim.cmd("lua require('mason-lspconfig').setup(doom.features.auto_install.settings.lsp)")
      vim.cmd("LspInstall " .. opts.args)
    end,
  },
}

return auto_install
