local lua = {}

lua.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "lua",

  --- Disables default LSP config
  --- @type boolean
  disable_lsp = false,
  --- Name of the language server
  --- @type string
  lsp_name = "sumneko_lua",
  --- Custom config to pass to nvim-lspconfig
  --- @type table|nil
  lsp_config = {
    formatter = {
      enabled = true,
    },
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  --- Disables null-ls formatting sources
  --- @type boolean
  disable_formatting = false,
  --- Mason.nvim package to auto install the formatter from
  --- @type string
  formatting_package = "stylua",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  formatting_provider = "builtins.formatting.stylua",
  --- Function to configure null-ls formatter
  --- @type function|nil
  formatting_config = nil,

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- Mason.nvim package to auto install the diagnostics provider from
  --- @type string
  diagnostics_package = "luacheck",
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.luacheck",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = nil,

  --- Config for the lua-dev plugin
  neodev = {
    library = {
      enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
      -- these settings will be used for your Neovim config directory
      runtime = true, -- runtime path
      types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      plugins = true, -- installed opt or start plugins in packpath
      -- you can also specify the list of plugins to make available as a workspace library
      -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    setup_jsonls = false, -- configures jsonls to provide completion for project specific .luarc.json files
    -- for your Neovim config directory, the config.library settings will be used as is
    -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
    -- for any other directory, config.library.enabled will be set to false
    override = function(_root_dir, _options) end,
    -- With lspconfig, Neodev will automatically setup your lua-language-server
    -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
    -- in your lsp start options
    -- WARN: Do not change this setting.
    lspconfig = false,
    -- much faster, but needs a recent built of lua-language-server
    -- needs lua-language-server >= 3.6.0
    pathStrict = true,
  },
}

lua.packages = {
  ["lua-dev.nvim"] = {
    "folke/neodev.nvim",
    commit = "0e3f5e763639951f96f9acbdc9f52a9fedf91b46",
    ft = "lua",
  },
}

local langs_utils = require("doom.modules.langs.utils")
lua.autocmds = {
  {
    "FileType",
    "lua",
    langs_utils.wrap_language_setup("lua", function()
      require("neodev").setup(doom.langs.lua.settings.neodev)

      local config = vim.tbl_deep_extend("force", doom.langs.lua.settings.lsp_config, {
        before_init = require("neodev.lsp").before_init,
      })

      if not lua.settings.disable_lsp then
        langs_utils.use_lsp_mason(lua.settings.lsp_name, {
          config = config,
        })
      end

      if not lua.settings.disable_treesitter then
        langs_utils.use_tree_sitter(lua.settings.treesitter_grammars)
      end

      if not lua.settings.disable_formatting then
        langs_utils.use_null_ls(
          lua.settings.formatting_package,
          lua.settings.formatting_provider,
          lua.settings.formatting_config
        )
      end
      if not lua.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          lua.settings.diagnostics_package,
          lua.settings.diagnostics_provider,
          lua.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
}

return lua
