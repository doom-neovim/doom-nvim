local go = {}

go.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "go",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "gopls",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "gofumpt",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.gofumpt",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "golangci-lint",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.golangci_lint",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
go.autocmds = {
  {
    "BufWinEnter",
    "*.go",
    langs_utils.wrap_language_setup("go", function()
      if not go.settings.disable_lsp then
        langs_utils.use_lsp_mason(go.settings.lsp_name, {
          config = go.settings.lsp_config,
        })
      end

      if not go.settings.disable_treesitter then
        langs_utils.use_tree_sitter(go.settings.treesitter_grammars)
      end

      if not go.settings.disable_formatting then
        langs_utils.use_null_ls(
          go.settings.formatting_package,
          go.settings.formatting_provider,
          go.settings.formatting_config
        )
      end
      if not go.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          go.settings.diagnostics_package,
          go.settings.diagnostics_provider,
          go.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return go
