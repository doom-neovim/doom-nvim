local log = require('doom.utils.logging')

local module = {}

--- Stores the unique null_ls sources
local registered_sources = {}
--- Registers a null_ls source only if it's unique
-- @tparam  source
module.use_null_ls_source = function(sources)
  local null_ls = require("null-ls")
  for _, source in ipairs(sources) do
    -- Generate a unique key from the name/methods
    local methods = type(source.method) == 'string' and source.method or table.concat(source.method, ' ')
    local key = source.name .. methods
    -- If it's unique, register it
    if not table[key] then
      table[key] = source
      null_ls.register(source)
    else
      log.warn(string.format('Attempted to register a duplicate null_ls source. ( %s with methods %s).', source.name, methods))
    end
  end
end

module.use_lsp = function(lsp_name, _opts)
  local utils = require('doom.utils')
  local lsp = require('lspconfig')
  local lsp_configs = require("lspconfig.configs")

  local opts = _opts or {}
  local config_name = opts.name and opts.name or lsp_name
  local is_custom_config = opts.name ~= nil or lsp_configs[config_name] ~= nil
  
  if opts.config and is_custom_config then
    lsp_configs[config_name] = opts.config
  end

  -- Combine default on_attach with provided on_attach
  local on_attach_functions = {}
  if not utils.is_plugin_disabled("illuminate") then
    table.insert(on_attach_functions, utils.illuminate_attach)
  end
  if (opts.config and opts.config.on_attach) then
    table.insert(on_attach_functions, opts.config.on_attach)
  end

  local capabilities_config = {
    capabilities = module.get_capabilities(),
    on_attach = function (client)
      for _, handler in ipairs(on_attach_functions) do
        handler(client)
      end
    end
  }

  -- Start server and bind to buffers
  local start_lsp = function(server)
    local final_config = vim.tbl_deep_extend('keep', opts.config or {}, capabilities_config)
    if server and not is_custom_config then -- If using lsp-installer 
      server:setup(final_config)
    else
      lsp[config_name].setup(final_config)
      local server = lsp[config_name]
      if server.manager then
        local buffer_handler = server.filetypes and server.manager.try_add_wrapper or server.manager.try_add
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          buffer_handler(bufnr)
        end
      end
    end
  end

  -- Auto install if possible
  if not utils.is_plugin_disabled('auto_install') and not opts.no_installer then
    local lsp_installer = require("nvim-lsp-installer.servers")
    local server_available, server = lsp_installer.get_server(lsp_name)
    if server_available then
      if not server:is_installed() then
        vim.defer_fn(function()
          server:install()
        end, 50)
      end

      server:on_ready(function()
        start_lsp(server)
      end)
    end
  else
    start_lsp()
  end
end

--- Helper to attach illuminate on LSP
module.illuminate_attach = function(client)
  require("illuminate").on_attach(client)
  -- Set underline highlighting for Lsp references
  vim.cmd("hi! LspReferenceText cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceWrite cterm=underline gui=underline")
  vim.cmd("hi! LspReferenceRead cterm=underline gui=underline")
end

--- Get LSP capabilities for DOOM
module.get_capabilities = function()
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

  return capabilities
end

return module
