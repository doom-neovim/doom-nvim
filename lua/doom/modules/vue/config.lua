local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled
local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
local lspconfig_util = require 'lspconfig/util'


-- volar needs works with typescript server, needs to get the typescript server from the project's node_modules
local function on_new_config(new_config, new_root_dir)
  local function get_typescript_server_path(root_dir)
    local project_root = lspconfig_util.find_node_modules_ancestor(root_dir)
    return project_root and (lspconfig_util.path.join(project_root, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js'))
      or ''
  end

  if
    new_config.init_options
    and new_config.init_options.typescript
    and new_config.init_options.typescript.serverPath == ''
  then
    new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
  end
end
local volar_root_dir = lspconfig_util.root_pattern 'package.json'

-- Runtime config with extra capabilities
local config = {
  capabilities = utils.get_capabilities(),
  on_attach = function(client)
    if not is_plugin_disabled("illuminate") then
      utils.illuminate_attach(client)
    end
    if type(doom.lua.on_attach) == "function" then
      doom.lua.on_attach(client)
    end
  end,
}

local volar = lspconfig.volar -- Get the volar config to set the `cmd`

-- Contains base configuration necessary for volar to start
local base_config = {
  default_config = {
    cmd = volar.document_config.default_config.cmd,
    root_dir = volar_root_dir,
    on_new_config = on_new_config,
    init_options = {
      typescript = {
        serverPath = ''
      }
    }
  }
}

lspconfig_configs.volar_api = vim.tbl_deep_extend('keep', base_config, doom.vue.volar_api)
lspconfig_configs.volar_doc = vim.tbl_deep_extend('keep', base_config, doom.vue.volar_doc)
lspconfig_configs.volar_html = vim.tbl_deep_extend('keep', base_config, doom.vue.volar_html)

--
local start_lsp = function()
  lspconfig.volar_api.setup(config)
  lspconfig.volar_doc.setup(config)
  lspconfig.volar_html.setup(config)
end

if not is_plugin_disabled("auto_install") then
  local lsp_installer = require("nvim-lsp-installer.servers")
  local server_available, server = lsp_installer.get_server("volar")
  if server_available then
    config.cmd_env = server:get_default_options().cmd_env
    if not server:is_installed() then
      vim.defer_fn(function()
        server:install()
      end, 50)
    end

    server:on_ready(function()
      start_lsp();
    end)
  end
else
  start_lsp()
end

vim.defer_fn(function()
  local ts_install = require('nvim-treesitter.install')
  ts_install.ensure_installed('vue', 'css', 'html', 'scss')
end, 0)
