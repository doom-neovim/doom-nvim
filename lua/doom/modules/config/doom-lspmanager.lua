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
    local modules = require("doom.core.config.modules").modules
    local langs = modules.langs

    for _, lang in ipairs(langs) do
      local lang_str = lang

      local should_try_install = lang_str:find('%+lsp')
      if should_try_install ~= nil then

        -- Get the Lang name without flags
        lang = lang:gsub("%s+%+lsp(%(%a+%))", ""):gsub("%s+%+lsp", ""):gsub("%s+%+debug", "")
        local lsp_name = servers[lang][1]

        -- Allow overriding of LSP using `+lsp(OVERRIDE_LSP_NAME)` syntax
        local lsp_override = lang_str:match("+lsp%((%a+)%)")
        if lsp_override ~= nil then
          -- Uninstall the default LSP to avoid conflicts
          if lspmanager.is_lsp_installed(lsp_name) == 1 then
            log.warn(
              "Uninstalling "
                .. lang
                .. " ("
                .. lsp_name
                .. ") "
                .. " LSP due to "
                .. lsp_override
                .. " LSP being supplied in config.  If you want to revert back to "
                .. lsp_name
                .. " LSP you will have to manually uninstall "
                .. lsp_override
                .. "."
            )
            lspmanager.uninstall(lsp_name)
          end
          lsp_name = lsp_override
        end

        -- If not installed, install it catching errors to be logged to terminal
        if lspmanager.is_lsp_installed(lsp_name) == 0 then
          local status, err = pcall(function () 
            print('Installing ' .. lsp_name)
            lspmanager.install(lsp_name);
          end)

          if (err) then
            log.warn('Error while installing LSP ('..lsp_name..') for '..lang..': ' .. err .. '.')
          end
        end
      else if lspmanager.is_lsp_installed(servers[lang][1]) then
        lspmanager.uninstall(servers[lang[1]])
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
