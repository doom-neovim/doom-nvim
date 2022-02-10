local vue = {}

vue.defaults = {
  -- Volar API lspconfig options
  volar_api = {
    default_config = {
      filetypes = { 'vue' },
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
            defaultTagNameCase = 'both',
            defaultAttrNameCase = 'kebabCase',
            getDocumentNameCasesRequest = false,
            getDocumentSelectionRequest = false,
          },
        }
      },
    }
  },
  -- Volar Document lspconfig options
  volar_doc = {
    default_config = {
      filetypes = { 'vue' },
      -- If you want to use Volar's Take Over Mode (if you know, you know):
      --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      init_options = {
        languageFeatures = {
          documentHighlight = true,
          documentLink = true,
          codeLens = { showReferencesNotification = true},
          -- not supported - https://github.com/neovim/neovim/pull/14122
          semanticTokens = false,
          diagnostics = true,
          schemaRequestService = true,
        }
      },
    }
  },
  volar_html = {
    default_config = {
      filetypes = { 'vue' },
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
        }
      },
    }
  }
}

vue.configure_functions = {}

vue.autocommands = {
  {
    "FileType",
    "vue",
    function()
      local utils = require("doom.utils")
      local is_plugin_disabled = utils.is_plugin_disabled
      local lspconfig = require("lspconfig")
      local lspconfig_util = require("lspconfig/util")
      local langs_utils = require('doom.modules.langs_utils')
      
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
      
      -- Runtime config with extra capabilities
      local config = langs_utils.lsp_ensure_client_capabilities({
        on_attach = function(client)
          if not is_plugin_disabled("illuminate") then
            utils.illuminate_attach(client)
          end
        end
      })
      local volar = lspconfig.volar -- Get the volar config to set the `cmd`
      
      -- Contains base configuration necessary for volar to start
      local base_config = vim.tbl_deep_extend('keep', config, {
        default_config = {
          cmd = volar.document_config.default_config.cmd,
          root_dir = volar_root_dir,
          on_new_config = on_new_config,
          init_options = {
            typescript = {
              serverPath = "",
            },
          },
        },
      })
      
      
      local volar_api_config = vim.tbl_deep_extend('force', {}, doom.vue.volar_api, base_config)
      langs_utils.use_lsp('volar', {
        name = 'volar_api',
        config = volar_api_config,
      })
      
      local volar_doc_config = vim.tbl_deep_extend('force', {}, doom.vue.volar_doc, base_config)
      langs_utils.use_lsp('volar', {
        name = 'volar_doc',
        config = volar_doc_config,
      })
      
      local volar_html_config = vim.tbl_deep_extend('force', {}, doom.vue.volar_html, base_config)
      langs_utils.use_lsp('volar', {
        name = 'volar_html',
        config = volar_html_config,
      })
      
      
      
      vim.defer_fn(function()
        local ts_install = require("nvim-treesitter.install")
        ts_install.ensure_installed("vue", "css", "html", "scss")
      end, 0)
      
      -- Setup null-ls
      if doom.linter then
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
