local bash = {}

bash.settings = {
  --- disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "bash",

  --- disables default lsp config
  --- @type boolean
  disable_lsp = false,
  --- name of the language server
  --- @type string
  lsp_name = "bashls",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "shfmt",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.shfmt",
  --- function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "shellcheck",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.shellcheck",
  --- function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,

  --- disables null-ls diagnostic sources
  --- @type boolean
  disable_code_actions = false,
  --- mason.nvim package to auto install the code_actions provider from
  --- @type string
  code_actions_package = "shellcheck",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  code_actions_provider = "builtins.code_actions.shellcheck",
  --- function to configure null-ls code_actions
  --- @type function|nil
  code_actions_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
bash.autocmds = {
  {
    "FileType",
    "bash,sh",
    langs_utils.wrap_language_setup("bash", function()
      if not bash.settings.disable_lsp then
        langs_utils.use_lsp_mason(bash.settings.lsp_name, {
          config = bash.settings.lsp_config,
        })
      end

      if not bash.settings.disable_treesitter then
        langs_utils.use_tree_sitter(bash.settings.treesitter_grammars)
      end

      if not bash.settings.disable_formatting then
        langs_utils.use_null_ls(
          bash.settings.formatting_package,
          bash.settings.formatting_provider,
          bash.settings.formatting_config
        )
      end
      if not bash.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          bash.settings.diagnostics_package,
          bash.settings.diagnostics_provider,
          bash.settings.diagnostics_config
        )
      end
      if not bash.settings.disable_code_actions then
        langs_utils.use_null_ls(
          bash.settings.code_actions_package,
          bash.settings.code_actions_provider,
          bash.settings.code_actions_config
        )
      end
    end),
    once = true,
  },
}

return bash
