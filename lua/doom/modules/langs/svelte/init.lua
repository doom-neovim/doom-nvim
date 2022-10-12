local svelte = {}

svelte.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "svelte",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "svelte",

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "eslint_d",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.eslint_d",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "eslint_d",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.eslint_d",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_code_actions = false,
  --- Mason.nvim package to auto install the code_actions provider from
  --- @type string
  code_actions_package = "eslint_d",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  code_actions_provider = "builtins.code_actions.eslint_d",
  --- Function to configure null-ls code_actions
  --- @type function|nil
  code_actions_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
svelte.autocmds = {
  {
    "FileType",
    "svelte",
    langs_utils.wrap_language_setup("svelte", function()
      if not svelte.settings.disable_lsp then
        langs_utils.use_lsp_mason(svelte.settings.lsp_name)
      end

      if not svelte.settings.disable_treesitter then
        langs_utils.use_tree_sitter(svelte.settings.treesitter_grammars)
      end

      if not svelte.settings.disable_formatting then
        langs_utils.use_null_ls(
          svelte.settings.diagnostics_package,
          svelte.settings.formatting_provider,
          svelte.settings.formatting_config
        )
      end
      if not svelte.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          svelte.settings.diagnostics_package,
          svelte.settings.diagnostics_provider,
          svelte.settings.diagnostics_config
        )
      end
      if not svelte.settings.disable_code_actions then
        langs_utils.use_null_ls(
          svelte.settings.code_actions_package,
          svelte.settings.code_actions_provider,
          svelte.settings.code_actions_config
        )
      end
    end),
    once = true,
  },
}

return svelte
