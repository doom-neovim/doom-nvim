local c_sharp = {}

c_sharp.settings = {
  --- disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "c_sharp",

  --- disables default lsp config
  --- @type boolean
  disable_lsp = false,
  --- name of the language server
  --- @type string
  lsp_name = "omnisharp",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|function|nil
  lsp_config = function()
    local lsp_util = require("lspconfig.util")
    return {
      cmd = { c_sharp.settings.lsp_name },
      root_dir = function(fname)
        return lsp_util.root_pattern("*.sln")(fname)
          or lsp_util.root_pattern("*.csproj")(fname)
          or lsp_util.root_pattern("ProjectSettings")(fname) -- Add support for unity projects
      end,
    }
  end,

  --- disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "csharpier",
  --- string to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.csharpier",
  --- function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,
}

local langs_utils = require("doom.modules.langs.utils")
c_sharp.autocmds = {
  {
    "FileType",
    "cs,vb",
    langs_utils.wrap_language_setup("c_sharp", function()
      vim.cmd("packadd nvim-lspconfig")

      if not c_sharp.settings.disable_lsp then
        langs_utils.use_lsp_mason(c_sharp.settings.lsp_name, {
          config = c_sharp.settings.lsp_config,
        })
      end

      if not c_sharp.settings.disable_treesitter then
        langs_utils.use_tree_sitter(c_sharp.settings.treesitter_grammars)
      end

      if not c_sharp.settings.disable_formatting then
        langs_utils.use_null_ls(
          c_sharp.settings.formatting_package,
          c_sharp.settings.formatting_provider,
          c_sharp.settings.formatting_config
        )
      end
    end),
    once = true,
  },
}

return c_sharp
