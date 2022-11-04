local rust = {}

rust.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "rust",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "rust_analyzer",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = {
    settings = {
      ['rust-analyzer'] = {
      }
    }
  },

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- WARN: No package yet.  Mason.nvim package to auto install the formatter from
  --- @type nil
  formatting_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.rustfmt",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
rust.autocmds = {
  {
    "FileType",
    "rust",
    langs_utils.wrap_language_setup("rust", function()
      if not rust.settings.disable_lsp then
        langs_utils.use_lsp_mason(rust.settings.lsp_name)
      end

      if not rust.settings.disable_treesitter then
        langs_utils.use_tree_sitter(rust.settings.treesitter_grammars)
      end

      if not rust.settings.disable_formatting then
        langs_utils.use_null_ls(
          rust.settings.formatting_package,
          rust.settings.formatting_provider,
          rust.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return rust
