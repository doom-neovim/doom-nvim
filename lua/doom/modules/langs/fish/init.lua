local fish = {}

fish.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "fish",

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- WARN: No package yet.  Mason.nvim package to auto install the formatter from
  --- @type nil
  formatting_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.fish_indent",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type nil
  diagnostics_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.fish",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
fish.autocmds = {
  {
    "FileType",
    "fish",
    langs_utils.wrap_language_setup("fish", function()
      if not fish.settings.disable_treesitter then
        langs_utils.use_tree_sitter(fish.settings.treesitter_grammars)
      end

      if not fish.settings.disable_formatting then
        langs_utils.use_null_ls(
          fish.settings.formatting_package,
          fish.settings.formatting_provider,
          fish.settings.formatting_config
        )
      end
      if not fish.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          fish.settings.diagnostics_package,
          fish.settings.diagnostics_provider,
          fish.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return fish
