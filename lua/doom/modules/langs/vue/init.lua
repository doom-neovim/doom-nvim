local vue = {}

vue.settings = {
  -- Volar API lspconfig options
  volar_api = {
    default_config = {
      filetypes = { "vue" },
      -- If you want to use Volar's Take Over Mode (if you know, you know)
      --filetypes = { 'vue', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      init_options = {
        languageFeatures = {
          references = true,
          definition = true,
          typeDefinition = true,
          callHierarchy = true,
          hover = true,
          rename = true,
          renameFileRefactoring = true,
          signatureHelp = true,
          codeAction = true,
          workspaceSymbol = true,
          completion = {
            defaultTagNameCase = "both",
            defaultAttrNameCase = "kebabCase",
            getDocumentNameCasesRequest = false,
            getDocumentSelectionRequest = false,
          },
        },
      },
    },
  },
  -- Volar Document lspconfig options
  volar_doc = {
    default_config = {
      filetypes = { "vue" },
      -- If you want to use Volar's Take Over Mode (if you know, you know):
      --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      init_options = {
        languageFeatures = {
          documentHighlight = true,
          documentLink = true,
          codeLens = { showReferencesNotification = true },
          -- not supported - https://github.com/neovim/neovim/pull/14122
          semanticTokens = false,
          diagnostics = true,
          schemaRequestService = true,
        },
      },
    },
  },
  volar_html = {
    default_config = {
      filetypes = { "vue" },
      -- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
      --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      init_options = {
        documentFeatures = {
          selectionRange = true,
          foldingRange = true,
          linkedEditingRange = true,
          documentSymbol = true,
          -- not supported - https://github.com/neovim/neovim/pull/13654
          documentColor = false,
          documentFormatting = {
            defaultPrintWidth = 100,
          },
        },
      },
    },
  },
}

vue.configs = {}

vue.autocmds = {
  {
    "BufWinEnter",
    "*.vue",
    function()
      local lspconfig_util = require("lspconfig/util")
      local langs_utils = require("doom.modules.langs.utils")

      -- volar needs works with typescript server, needs to get the typescript server from the project's node_modules
      local function on_new_config(new_config, new_root_dir)
        local function get_typescript_server_path(root_dir)
          local project_root = lspconfig_util.find_node_modules_ancestor(root_dir)
          return project_root
              and (lspconfig_util.path.join(
                project_root,
                "node_modules",
                "typescript",
                "lib",
                "tsserverlibrary.js"
              ))
            or ""
        end

        if
          new_config.init_options
          and new_config.init_options.typescript
          and new_config.init_options.typescript.serverPath == ""
        then
          new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
        end
      end
      local volar_root_dir = lspconfig_util.root_pattern("package.json")

      -- Contains base configuration necessary for volar to start
      local base_config = {
        default_config = {
          cmd = { "vue-language-server", "--stdio" },
          -- cmd = volar.document_config.default_config.cmd,
          root_dir = volar_root_dir,
          on_new_config = on_new_config,
          init_options = {
            typescript = {
              serverPath = "",
            },
          },
        },
      }

      local volar_api_config =
        vim.tbl_deep_extend("force", {}, doom.langs.vue.settings.volar_api, base_config)
      langs_utils.use_lsp("volar", {
        name = "volar_api",
        config = volar_api_config,
      })

      local volar_doc_config =
        vim.tbl_deep_extend("force", {}, doom.langs.vue.settings.volar_doc, base_config)
      langs_utils.use_lsp("volar", {
        name = "volar_doc",
        config = volar_doc_config,
      })

      local volar_html_config =
        vim.tbl_deep_extend("force", {}, doom.langs.vue.settings.volar_html, base_config)
      langs_utils.use_lsp("volar", {
        name = "volar_html",
        config = volar_html_config,
      })

      vim.defer_fn(function()
        local ts_install = require("nvim-treesitter.install")
        ts_install.ensure_installed(
          "vue",
          "css",
          "scss",
          "html",
          "scss",
          "javascript",
          "typescript"
        )
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
        })
      end
    end,
    once = true,
  },
}

return vue
