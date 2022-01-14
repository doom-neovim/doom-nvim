local vue = {}

vue.defaults = {
  -- Volar API lspconfig options
  volar_api = {
    default_config = {
      filetypes = { 'vue' },
      -- If you want to use Volar's Take Over Mode (if you know, you know)
      --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
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

vue.packer_config = {}

return vue
