local config = {}

-- TODO: Investigate broken yaml/toml language servers

config.settings = {
  json_schemas = {
    ".eslintrc",
    "package.json",
    "prettierrc.json",
    "tsconfig.json",
  },
  json_language_server_name = "jsonls",
  -- toml_language_server_name = 'taplo', -- Currently broken
  -- yaml_language_server_name = 'yamlls', -- Currently broken
}

config.packages = {
  ["SchemaStore.nvim"] = {
    "b0o/SchemaStore.nvim",
    commit = "f55842dc797faad8cf7b0d9ce75c59da654aa018",
    ft = { "json", "yaml", "toml" },
  },
}
config.configs = {}
config.configs["SchemaStore.nvim"] = function()
  local langs_utils = require("doom.modules.langs.utils")
  langs_utils.use_lsp(doom.langs.config.settings.json_language_server_name, {
    config = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas({
            select = doom.langs.config.settings.json_schemas,
          }),
        },
      },
    },
  })
end

config.autocmds = {
  {
    "BufWinEnter",
    "*.json,*.yaml,*.toml",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      -- langs_utils.use_lsp(doom.langs.config.settings.toml_language_server_name)
      -- langs_utils.use_lsp(doom.langs.config.settings.yaml_language_server_name)

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("json5", "yaml", "toml")
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
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
