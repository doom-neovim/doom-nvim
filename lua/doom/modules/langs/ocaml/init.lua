local ocaml = {}

ocaml.settings = {
  --- disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = { "ocaml", "ocaml_interface", "ocamllex" },

  --- disables default lsp config
  --- @type boolean
  disable_lsp = false,
  --- name of the language server
  --- @type string
  lsp_name = "ocamllsp",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
ocaml.autocmds = {
  {
    "FileType",
    "ocaml",
    langs_utils.wrap_language_setup("ocaml", function()
      if not ocaml.settings.disable_lsp then
        langs_utils.use_lsp_mason(ocaml.settings.lsp_name, {
          config = ocaml.settings.lsp_config,
        })
      end

      if not ocaml.settings.disable_treesitter then
        langs_utils.use_tree_sitter(ocaml.settings.treesitter_grammars)
      end
    end),
    once = true,
  },
}

return ocaml
