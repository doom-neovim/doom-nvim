local tailwindcss = {}

tailwindcss.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = { "css", "html", "vue" },

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "tailwindcss",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- WARN: No package yet. Mason.nvim package to auto install the formatter from
  --- @type nil
  formatting_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.rustywind",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
tailwindcss.autocmds = {
  {
    "FileType",
    "javascript,typescript,javascriptreact,typescriptreact,css,html,vue,svelte",
    langs_utils.wrap_language_setup("tailwindcss", function()
      if not tailwindcss.settings.disable_lsp then
        langs_utils.use_lsp_mason(tailwindcss.settings.lsp_name, {
          config = tailwindcss.settings.lsp_config,
        })
      end

      if not tailwindcss.settings.disable_treesitter then
        langs_utils.use_tree_sitter(tailwindcss.settings.treesitter_grammars)
      end

      if not tailwindcss.settings.disable_formatting then
        langs_utils.use_null_ls(
          tailwindcss.settings.formatting_package,
          tailwindcss.settings.formatting_provider,
          tailwindcss.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return tailwindcss
