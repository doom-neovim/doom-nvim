local python = {}

python.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "python",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "pyright",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "black",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.black",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "mypy",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.mypy",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
python.autocmds = {
  {
    "FileType",
    "python",
    langs_utils.wrap_language_setup("python", function()
      if not python.settings.disable_lsp then
        langs_utils.use_lsp_mason(python.settings.lsp_name, {
          config = python.settings.lsp_config,
        })
      end

      if not python.settings.disable_treesitter then
        langs_utils.use_tree_sitter(python.settings.treesitter_grammars)
      end

      if not python.settings.disable_formatting then
        langs_utils.use_null_ls(
          python.settings.formatting_package,
          python.settings.formatting_provider,
          python.settings.formatting_config
        )
      end
      if not python.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          python.settings.diagnostics_package,
          python.settings.diagnostics_provider,
          python.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return python
