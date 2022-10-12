local typescript = {}

typescript.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "toml",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "taplo",

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "taplo",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.taplo",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
typescript.autocmds = {
  {
    "FileType",
    "toml",
    langs_utils.wrap_language_setup("toml", function()
      if not typescript.settings.disable_lsp then
        langs_utils.use_lsp_mason(typescript.settings.lsp_name)
      end

      if not typescript.settings.disable_treesitter then
        langs_utils.use_tree_sitter(typescript.settings.treesitter_grammars)
      end

      if not typescript.settings.disable_formatting then
        langs_utils.use_null_ls(
          typescript.settings.formatting_package,
          typescript.settings.formatting_provider,
          typescript.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return typescript
