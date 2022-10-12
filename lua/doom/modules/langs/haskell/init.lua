local haskell = {}

haskell.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "haskell",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "hls",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- WARN: No package. Mason.nvim package to auto install the formatter from
  --- @type nil
  formatting_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.fourmolu",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
haskell.autocmds = {
  {
    "FileType",
    "haskell",
    langs_utils.wrap_language_setup("haskell", function()
      if not haskell.settings.disable_lsp then
        print("starting lsp")
        langs_utils.use_lsp_mason(haskell.settings.lsp_name, {
          config = haskell.settings.lsp_config,
        })
      end

      if not haskell.settings.disable_treesitter then
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.haskell = {
          install_info = {
            url = "https://github.com/tree-sitter/tree-sitter-haskell",
            files = { "src/parser.c", "src/scanner.c" },
          },
        }
        langs_utils.use_tree_sitter(haskell.settings.treesitter_grammars)
      end

      if not haskell.settings.disable_formatting then
        langs_utils.use_null_ls(
          haskell.settings.diagnostics_package,
          haskell.settings.formatting_provider,
          haskell.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return haskell
