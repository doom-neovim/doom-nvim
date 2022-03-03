local config = {}

-- TODO: Investigate broken yaml/toml language servers

config.settings = {
  json_schemas = {
    '.eslintrc',
    'package.json',
    'prettierrc.json',
    'tsconfig.json'
  },
  json_language_server_name = 'jsonls',
  -- toml_language_server_name = 'taplo', -- Currently broken
  -- yaml_language_server_name = 'yamlls', -- Currently broken
}

config.packages = {
  ["SchemaStore.nvim"] = {
    "b0o/SchemaStore.nvim",
    commit = "df5e98d3b3c93e9857908fce8a219360f81c5e32",
    ft = { "json", "yaml", "toml" }
  },
}
config.configure_functions = {}
config.configure_functions["SchemaStore.nvim"] = function()
  local langs_utils = require('doom.modules.langs.utils')
  langs_utils.use_lsp(doom.modules.config.settings.json_language_server_name, {
    config = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas {
            select = doom.modules.config.settings.json_schemas,
          },
        },
      },
    }
  })
end

config.autocommands = {
  {
    "FileType",
    "json,yaml,toml",
    function()
      -- langs_utils.use_lsp(doom.modules.config.settings.toml_language_server_name)
      -- langs_utils.use_lsp(doom.modules.config.settings.yaml_language_server_name)

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("json5", "yaml", "toml")
      end, 0)

      -- Setup null-ls
      if doom.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          -- null_ls.builtins.formatting.taplo,
          -- null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.diagnostics.jsonlint,
        })
      end

    end,
    once = true,
  },
}

return config
