return function()
  local log = require("doom.extras.logging")
  local utils = require("doom.utils")
  local nvim_lsp = require("lspconfig")
  local is_plugin_disabled = require("doom.core.functions").is_plugin_disabled

  -- Snippets support
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.codeAction = {
    dynamicRegistration = false,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = {
          "",
          "quickfix",
          "refactor",
          "refactor.extract",
          "refactor.inline",
          "refactor.rewrite",
          "source",
          "source.organizeImports",
        },
      },
    },
  }

  -- Load langs from doom_modules and install servers with +lsp flag
  local function install_servers()
    local lspinstall = require("lspinstall")
    lspinstall.setup()

    local installed_servers = lspinstall.installed_servers()
    local available_servers = lspinstall.available_servers()

    local modules = require("doom.core.config.modules").modules
    local langs = modules.langs

    for _, lang in ipairs(langs) do
      local lang_str = lang
      lang = lang:gsub("%s+%+lsp", ""):gsub("%s+%+debug", "")

      -- If the +lsp flag exists and the language server is not installed yet
      if lang_str:find("%+lsp") and (not utils.has_value(installed_servers, lang)) then
        -- Try to install the server only if there is a server available for
        -- the language, oterwise raise a warning
        if utils.has_value(available_servers, lang) then
          lspinstall.install_server(lang)
        else
          log.warn(
            "The language " .. lang .. ' does not have a server, please remove the "+lsp" flag'
          )
        end
      end
    end
  end

  install_servers()

  --- Intelligent highlighting of word under cursor
  local on_attach
  if not is_plugin_disabled("illuminated") and packer_plugins["vim-illuminate"] then
    on_attach = function(client)
      require("illuminate").on_attach(client)
      -- Set underline highlighting for Lsp references
      vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
      vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
      vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")
    end
  end

  local lua_lsp = require("lua-dev").setup({
    lspconfig = {
      settings = {
        Lua = {
          workspace = {
            preloadFileSize = 200,
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    },
  })

  -- https://github.com/kabouzeid/nvim-lspinstall#advanced-configuration-recommended
  local function setup_servers()
    -- Provide the missing :LspInstall
    require("lspinstall").setup()

    local servers = require("lspinstall").installed_servers()
    for _, server in pairs(servers) do
      -- Configure sumneko for neovim lua development
      if server == "lua" then
        nvim_lsp.lua.setup(lua_lsp)
      else
        -- Use default settings for all the other language servers
        nvim_lsp[server].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end
    end
  end

  setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require("lspinstall").post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end
end
