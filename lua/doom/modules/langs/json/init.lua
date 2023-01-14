local json = {}

json.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "json",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "jsonls",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|function|nil
  lsp_config = function()
    return {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
        },
      },
    }
  end,

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "fixjson",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.fixjson",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

json.packages = {
  ["SchemaStore.nvim"] = {
    "b0o/SchemaStore.nvim",
    commit = "571056608b7fc569f856c8174fcbffaad548eec5",
    ft = "json",
  },
}

local langs_utils = require("doom.modules.langs.utils")
json.autocmds = {
  {
    "FileType",
    "json",
    langs_utils.wrap_language_setup("json", function()
      -- require("lazy").load("SchemaStore.nvim")
      if not json.settings.disable_lsp then
        langs_utils.use_lsp_mason(json.settings.lsp_name, {
          config = json.settings.lsp_config,
        })
      end

      if not json.settings.disable_treesitter then
        langs_utils.use_tree_sitter(json.settings.treesitter_grammars)
      end

      if not json.settings.disable_formatting then
        langs_utils.use_null_ls(
          json.settings.diagnostics_package,
          json.settings.formatting_provider,
          json.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return json
