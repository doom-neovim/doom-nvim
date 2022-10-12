local kotlin = {}

kotlin.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "kotlin",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "kotlin_language_server",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "ktlint",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.ktlint",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "ktlint",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.ktlint",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
kotlin.autocmds = {
  {
    "FileType",
    "kotlin",
    langs_utils.wrap_language_setup("kotlin", function()
      if not kotlin.settings.disable_lsp then
        langs_utils.use_lsp_mason(kotlin.settings.lsp_name, {
          config = kotlin.settings.lsp_config,
        })
      end

      if not kotlin.settings.disable_treesitter then
        langs_utils.use_tree_sitter(kotlin.settings.treesitter_grammars)
      end

      if not kotlin.settings.disable_formatting then
        langs_utils.use_null_ls(
          kotlin.settings.formatting_package,
          kotlin.settings.formatting_provider,
          kotlin.settings.formatting_config
        )
      end
      if not kotlin.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          kotlin.settings.diagnostics_package,
          kotlin.settings.diagnostics_provider,
          kotlin.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return kotlin
