local gdscript = {}

gdscript.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = { "gdscript", "godot_resource" },

  -- --- Disables default LSP config
  -- --- @type boolean
  -- disable_lsp = false,
  -- --- Name of the language server
  -- --- @type string
  -- lsp_name = "tsserver",

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- WARN: No package yet. Mason.nvim package to auto install the formatter from
  --- @type nil
  formatting_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.gdformat",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- WARN: No package yet. Mason.nvim package to auto install the diagnostics provider from
  --- @type nil
  diagnostics_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.gdlint",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
gdscript.autocmds = {
  {
    "BufWinEnter",
    "*.gd",
    langs_utils.wrap_language_setup("gdscript", function()
      if not gdscript.settings.disable_lsp then
        langs_utils.use_lsp_mason(gdscript.settings.lsp_name, {
          no_installer = true,
          config = {
            flags = {
              debounce_text_changes = 150,
            },
          },
        })
      end

      if not gdscript.settings.disable_treesitter then
        langs_utils.use_tree_sitter(gdscript.settings.treesitter_grammars)
      end

      if not gdscript.settings.disable_formatting then
        langs_utils.use_null_ls(
          gdscript.settings.formatting_package,
          gdscript.settings.formatting_provider,
          gdscript.settings.formatting_config
        )
      end
      if not gdscript.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          gdscript.settings.diagnostics_package,
          gdscript.settings.diagnostics_provider,
          gdscript.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return gdscript
