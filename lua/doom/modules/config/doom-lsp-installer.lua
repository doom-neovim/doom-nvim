return function()
  local log = require("doom.extras.logging")
  local utils = require("doom.utils")
  local is_plugin_disabled = require("doom.utils").is_plugin_disabled

  -- Commented out defualt servers don't have treesitter configs
  local servers = {
    lua = { "sumneko_lua" },
    ansible = { "ansiblels" },
    angular = { "angularls" },
    bash = { "bashls" },
    -- bicep = { 'bicep' },
    c_sharp = { "omnisharp" },
    c = { "clangd" },
    cpp = { "clangd" },
    cmake = { "cmake" },
    css = { "cssls" },
    clojure = { "clojure_lsp" },
    -- codeql = { 'codeqlls' },
    -- deno = { 'denols' },
    -- dlang = { 'serve_d' },
    dockerfile = { "dockerls" },
    dot = { "dotls" },
    elixer = { "elixerls" },
    elm = { "elmls" },
    ember = { "ember" },
    fortran = { "fortls" },
    -- ['f#'] = { 'fsautocomplete' },
    go = { "gopls" },
    graphql = { "graphql" },
    groovy = { "groovyls" },
    html = { "html" },
    haskel = { "hls" },
    json = { "jsonls" },
    json5 = { "jsonls" },
    java = { "jdtls" },
    javascript = { "tsserver" },
    kotlin = { "kotlin_language_server" },
    latex = { "texlab" },
    ocaml = { "ocamells" },
    php = { "phpactor" },
    powershell = { "powershell_es" },
    -- prisma = { 'prismals' },
    -- puppet = { 'puppet' },
    -- purescript = { 'purescriptls' },
    python = { "pyright" },
    -- rescript = { 'rescriptls' },
    -- rome = { 'rome' },
    ruby = { "solargraph" },
    rust = { "rust_analyzer" },
    -- solang = { 'solang' },
    -- sorbet = { 'sorbet' },
    svelte = { "svelte" },
    typescript = { "tsserver" },
    -- vala = { 'valals' },
    vim = { "vimls" },
    vue = { "vuels" },
    xml = { "lemminx" },
    yaml = { "yamlls" },
    config = { "jsonls", "yamlls" },
  }
  -- Add out-of-the-box support for Scala metals LSP
  local should_setup_scala_lsp = false

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
          diagnostics = {
            globals = { "packer_plugins" },
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    },
  })

  -- Load langs from doom_modules, install servers with +lsp flag and sets up their config
  local function setup_servers()
    local lsp_installer = require("nvim-lsp-installer")

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
          if lang:find("scala") then
            -- Enable setup for Scala Metals LSP
            should_setup_scala_lsp = true
          else
            log.error(
              'The language "' .. lang .. '" does not have an LSP, please remove the "+lsp" flag.'
            )
          end
        end
      end
    end

    -- Flatten the array of default servers.
    -- Default servers will be automatically uninstalled if no +lsp flag is provided.
    local default_servers = {}
    for _, lang_servers in pairs(servers) do
      for _, lsp_name in ipairs(lang_servers) do
        if not utils.has_value(default_servers, lsp_name) then
          table.insert(default_servers, lsp_name)
        end
      end
    end
    -- Save which servers were installed/uninstalled so this info can be presented to user
    local installing_servers = {}
    local uninstalling_servers = {}
    -- Install all LSPs that should be installed
    for _, lsp_name in ipairs(default_servers) do
      local ok, server = lsp_installer.get_server(lsp_name)
      if ok then
        if not utils.has_value(ensure_installed, lsp_name) then
          if server:is_installed() then
            table.insert(uninstalling_servers, lsp_name)
            server:uninstall()
            log.info("doom-lsp-installer: Uninstalling server " .. lsp_name .. ".")
          end
        else
          local server_config = server.name == "sumneko_lua" and lua_lsp
            or {
              capabilities = capabilities,
              on_attach = on_attach,
            }
          -- Setup server once it's ready
          server:on_ready(function()
            server:setup(server_config)
          end)
          if not server:is_installed() then
            table.insert(installing_servers, lsp_name)
            server:install()
            log.info("doom-lsp-installer: Installing server " .. lsp_name .. ".")
          end
        end
      end
    end

    -- Install and setup non-default LSPs
    for _, lsp_name in ipairs(ensure_installed) do
      if not utils.has_value(default_servers, lsp_name) then
        local ok, server = lsp_installer.get_server(lsp_name)

        if ok then
          server:on_ready(function()
            server:setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end)
          if not server:is_installed() then
            table.insert(installing_servers, lsp_name)
            server:install()
            log.info("doom-lsp-installer: Installing server " .. lsp_name .. ".")
          end
        end
      end
    end

    -- Setup Scala Metals LSP
    if should_setup_scala_lsp then
      require("lspconfig").metals.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end

    -- Print intalling/uninstalling information to user on startup
    if next(installing_servers) ~= nil or next(uninstalling_servers) ~= nil then
      local msg = "Doom: "
      local installing_count = #installing_servers
      if installing_count > 0 then
        msg = msg .. "Installing " .. installing_count .. " LSPs.  "
      end
      local uninstalling_count = #uninstalling_servers
      if uninstalling_count > 0 then
        msg = msg .. "Uninstalling " .. installing_count .. " LSPs.  "
      end
      msg = msg .. "Use :LspInstallInfo to check status.  "
      vim.notify(msg)
    end
  end

  -- Defer auto install to unblock startup
  vim.defer_fn(function()
    setup_servers()
  end, 50)
end
