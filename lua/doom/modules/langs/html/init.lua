local html = {}

html.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = { "html", "javascript", "css" },

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "html",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "rome",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.rome",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = function(rome)
    rome.with({
      filetypes = { "html" },
    })
  end,
}

local langs_utils = require("doom.modules.langs.utils")
html.autocmds = {
  {
    "BufWinEnter",
    "*.html",
    langs_utils.wrap_language_setup("html", function()
      if not html.settings.disable_lsp then
        langs_utils.use_lsp_mason(html.settings.lsp_name, {
          config = html.settings.lsp_config,
        })
      end

      if not html.settings.disable_treesitter then
        langs_utils.use_tree_sitter(html.settings.treesitter_grammars)
      end

      if not html.settings.disable_formatting then
        langs_utils.use_null_ls(
          html.settings.diagnostics_package,
          html.settings.formatting_provider,
          html.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return html
