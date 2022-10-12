local dockerfile = {}

dockerfile.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "dockerfile",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "dockerls",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "hadolint",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.hadolint",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
dockerfile.autocmds = {
  {
    "FileType",
    "dockerfile",
    langs_utils.wrap_language_setup("dockerfile", function()
      if not dockerfile.settings.disable_lsp then
        langs_utils.use_lsp_mason(dockerfile.settings.lsp_name, {
          config = dockerfile.settings.lsp_config,
        })
      end

      if not dockerfile.settings.disable_treesitter then
        langs_utils.use_tree_sitter(dockerfile.settings.treesitter_grammars)
      end

      if not dockerfile.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          dockerfile.settings.diagnostics_package,
          dockerfile.settings.diagnostics_provider,
          dockerfile.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return dockerfile
