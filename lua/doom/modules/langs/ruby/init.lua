local ruby = {}

ruby.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "ruby",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "solargraph",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "rubocop",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.rubocop",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
ruby.autocmds = {
  {
    "FileType",
    "ruby",
    langs_utils.wrap_language_setup("ruby", function()
      if not ruby.settings.disable_lsp then
        langs_utils.use_lsp_mason(ruby.settings.lsp_name, {
          config = ruby.settings.lsp_config,
        })
      end

      if not ruby.settings.disable_treesitter then
        langs_utils.use_tree_sitter(ruby.settings.treesitter_grammars)
      end

      if not ruby.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          ruby.settings.diagnostics_package,
          ruby.settings.diagnostics_provider,
          ruby.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return ruby
