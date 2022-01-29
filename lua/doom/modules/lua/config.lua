local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled
local lspconfig = require("lspconfig")

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local config = vim.tbl_deep_extend("force", doom.lua, {
  settings = {
    Lua = {
      runtime = {
        path = runtime_path,
      },
    },
  },
  capabilities = utils.get_capabilities(),
  on_attach = function(client)
    if not is_plugin_disabled("illuminate") then
      utils.illuminate_attach(client)
    end
    if type(doom.lua.on_attach) == "function" then
      doom.lua.on_attach(client)
    end
  end,
})
local start_lsp = function()
  lspconfig.sumneko_lua.setup(config)
end

if not is_plugin_disabled("auto_install") then
  local lsp_installer = require("nvim-lsp-installer.servers")
  local server_available, server = lsp_installer.get_server("sumneko_lua")
  if server_available then
    config.cmd_env = server:get_default_options().cmd_env
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

vim.defer_fn(function()
  require("nvim-treesitter.install").ensure_installed("lua")
end, 0)

-- Setup null-ls
if doom.linter then
  print('registering stylua ')
  local null_ls = require('null-ls')
  null_ls.register( null_ls.builtins.formatting.stylua )
end

