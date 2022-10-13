local css = {}

css.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "css",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "cssls",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "stylelint-lsp",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.stylelint",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "stylelint-lsp",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.stylelint",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
css.autocmds = {
  {
    "FileType",
    "css,scss,vue,svelte,html",
    langs_utils.wrap_language_setup("css", function()
      if not css.settings.disable_lsp then
        langs_utils.use_lsp_mason(css.settings.lsp_name, {
          config = css.settings.lsp_config,
        })
      end

      if not css.settings.disable_treesitter then
        langs_utils.use_tree_sitter(css.settings.treesitter_grammars)
      end

      if not css.settings.disable_formatting then
        langs_utils.use_null_ls(
          css.settings.formatting_package,
          css.settings.formatting_provider,
          css.settings.formatting_config
        )
      end
      if not css.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          css.settings.diagnostics_package,
          css.settings.diagnostics_provider,
          css.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return css
