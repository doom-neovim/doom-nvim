return function()
  local log = require("doom.extras.logging")
  local utils = require("doom.utils")
  local nvim_lsp = require("lspconfig")
  local lspmanager = require("lspmanager")
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled

  local servers = {
    lua = { "sumneko_lua" },
    angular = { "angularls" },
    bash = { "bashls" },
    c = { "clangd" },
    cpp = { "clangd" },
    go = { "gopls" },
    cmake = { "cmake" },
    css = { "cssls" },
    html = { "html" },
    javascript = { "tsserver" },
    typescript = { "tsserver" },
    json = { "jsonls" },
    docker = { "dockerls" },
    python = { "pyright" },
    rust = { "rust_analyzer" },
    elixir = { "elixirls" },
    haskell = { "hls" },
    vue = { "vuels" },
    config = { "jsonls" },
  }

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
    local installed_servers = lspmanager.installed_servers()
    -- Flatten the array of default servers.  Default servers will be automatically uninstalled if no +lsp flag is provided.
    local default_servers = {}
    for _, lang_servers in pairs(servers) do
      for _, lsp_name in ipairs(lang_servers) do
        table.insert(default_servers, lsp_name)
      end
    end

    local modules = require("doom.core.config.modules").modules
    local langs = modules.langs

    -- Find all LSPs that need to be installed
    local ensure_installed = {}
    for _, lang in ipairs(langs) do
      -- Lang name used for key in servers table
      local lang_name = lang
        :gsub("%s+%+lsp(%(%a+%))", "")
        :gsub("%s+%+lsp", "")
        :gsub("%s+%+debug", "")
      -- Get LSP override +lsp(<override>) if it exists
      local lsp_override = lang:match("+lsp%((.+)%)")
      -- Array of lsps to ensure are installed
      local lang_lsps = lsp_override ~= nil and vim.split(lsp_override, ",")
        or servers[lang_name] ~= nil and servers[lang_name]
        or nil

      local should_install_lsp = lang:find("+lsp")

      -- Save all lsps to ensure_installed
      if should_install_lsp then
        if lang_lsps ~= nil then
          for _, lsp_name in ipairs(lang_lsps) do
            local trimmed_lsp_name = vim.trim(lsp_name)
            if utils.has_value(ensure_installed, trimmed_lsp_name) == false then
              table.insert(ensure_installed, trimmed_lsp_name)
            end
          end
        else
          log.error(
            'The language "' .. lang .. '" does not have an LSP, please remove the "+lsp" flag.'
          )
        end
      end
    end

    -- Uninstall all (default) LSPs that shouldn't be installed
    for _, lsp_name in ipairs(default_servers) do
      if
        utils.has_value(ensure_installed, lsp_name) == false
        and utils.has_value(installed_servers, lsp_name)
      then
        lspmanager.uninstall(lsp_name)
      end
    end

    -- Install all LSPs that should be installed
    for _, lsp_name in ipairs(ensure_installed) do
      if utils.has_value(installed_servers, lsp_name) == false then
        lspmanager.install(lsp_name)
      end
    end
  end

  install_servers()

  --- Intelligent highlighting of w ord under cursor
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
          diagnostics = {
            globals = { "packer_plugins" },
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    },
  })

  local function setup_servers()
    -- Provide the missing :LspInstall
    lspmanager.setup()

    local installed_servers = lspmanager.installed_servers()
    for _, server in pairs(installed_servers) do
      -- Configure sumneko for neovim lua development
      if server == "sumneko_lua" then
        nvim_lsp.sumneko_lua.setup(lua_lsp)
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
end
