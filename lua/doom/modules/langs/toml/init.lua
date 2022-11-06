---@toc doom.langs.toml
---@text # TOML
---
--- Adds TOML language support to doom nvim.
---
local toml = {}

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "core.toml")
toml.settings = {
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
---@eval return doom.core.doc_gen.generate_autocmds_documentation("langs.toml")
toml.autocmds = {
  {
    "FileType",
    "toml",
    langs_utils.wrap_language_setup("toml", function()
      if not toml.settings.disable_lsp then
        langs_utils.use_lsp_mason(toml.settings.lsp_name)
      end

      if not toml.settings.disable_treesitter then
        langs_utils.use_tree_sitter(toml.settings.treesitter_grammars)
      end

      if not toml.settings.disable_formatting then
        langs_utils.use_null_ls(
          toml.settings.formatting_package,
          toml.settings.formatting_provider,
          toml.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return toml
