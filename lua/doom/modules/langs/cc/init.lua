local utils = require("doom.utils")

local cc = {}

cc.settings = {
  --- disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = { "c", "cpp" },

  --- disables default lsp config
  --- @type boolean
  disable_lsp = false,
  --- name of the language server
  --- @type string
  lsp_name = "clangd",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
  },

  --- disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  ---Mason.nvim package to auto install the formatter from.
  --- @type string
  formatting_package = "clang-format",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.clang_format",
  --- function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "cpplint",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.cpplint",
  --- function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
cc.autocmds = {
  {
    "FileType",
    "cpp,c",
    langs_utils.wrap_language_setup("cc", function()
      if not cc.settings.disable_lsp then
        langs_utils.use_lsp_mason(cc.settings.lsp_name, {
          config = cc.settings.lsp_config,
        })
      end

      if not cc.settings.disable_treesitter then
        langs_utils.use_tree_sitter(cc.settings.treesitter_grammars)
      end

      if not cc.settings.disable_formatting then
        langs_utils.use_null_ls(
          cc.settings.formatting_package,
          cc.settings.formatting_provider,
          cc.settings.formatting_config
        )
      end
      if not cc.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          cc.settings.diagnostics_package,
          cc.settings.diagnostics_provider,
          cc.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return cc
