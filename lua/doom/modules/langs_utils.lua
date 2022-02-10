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


module.use_lsp = function(lsp_name, opts)
  local lsp = require('lspconfig')
  local lsp_configs = require("lspconfig.configs")

  -- Apply or merge lsp configs
  local config_name = opts.name and opts.name or lsp_name
  if opts.config then
    if lsp_configs[config_name] then
      lsp_configs[config_name] = vim.tbl_deep_extend('force', lsp_configs[config_name], opts.config)
    else
      lsp_configs[config_name] = opts.config
    end
  end

  -- Start server and bind to buffers
  local start_lsp = function()
    lsp[config_name].setup({})
    local server = lsp[config_name]
    local buffer_handler = server.filetypes and server.manager.try_add_wrapper or server.manager.try_add
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      buffer_handler(bufnr)
    end
  end

  -- Auto install if possible
  if not utils.is_plugin_disabled('auto_install') and not opts.no_installer then
    local lsp_installer = require("nvim-lsp-installer.servers")
    local server_available, server = lsp_installer.get_server(lsp_name)
    if server_available then
      lsp_configs[config_name].cmd_env = server:get_default_options().cmd_env
      if not server:is_installed() then
        vim.defer_fn(function()
          server:install()
        end, 50)
      end

      server:on_ready(function()
        start_lsp()
      end)
    end
  else
    start_lsp()
  end
end

return module
