local php = {}

php.settings = {
  --- disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "php",

  --- disables default lsp config
  --- @type boolean
  disable_lsp = false,
  --- name of the language server
  --- @type string
  lsp_name = "intelephense",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "php-cs-fixer",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.phpcsfixer",
  --- function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "phpstan",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.phpstan",
  --- function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
php.autocmds = {
  {
    "FileType",
    "php,phtml",
    langs_utils.wrap_language_setup("php", function()
      if not php.settings.disable_lsp then
        langs_utils.use_lsp_mason(php.settings.lsp_name, {
          config = php.settings.lsp_config,
        })
      end

      if not php.settings.disable_treesitter then
        langs_utils.use_tree_sitter(php.settings.treesitter_grammars)
      end

      if not php.settings.disable_formatting then
        langs_utils.use_null_ls(
          php.settings.formatting_package,
          php.settings.formatting_provider,
          php.settings.formatting_config
        )
      end
      if not php.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          php.settings.diagnostics_package,
          php.settings.diagnostics_provider,
          php.settings.diagnostics_config
        )
      end
      if not php.settings.disable_code_actions then
        langs_utils.use_null_ls(
          php.settings.code_actions_package,
          php.settings.code_actions_provider,
          php.settings.code_actions_config
        )
      end
    end),
    once = true,
  },
}

return php
