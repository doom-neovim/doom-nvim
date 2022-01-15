local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled
local lspconfig = require("lspconfig")

local config = vim.tbl_deep_extend("force", doom.lua, {
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

if not is_plugin_disabled("auto_install") then
  local lsp_installer = require("nvim-lsp-installer.servers")
  local server_available, server = lsp_installer.get_server("tsserver")
  if server_available then
    config.cmd_env = server:get_default_options().cmd_env
    if not server:is_installed() then
      vim.defer_fn(function()
        server:install()
      end, 50)
    end

    server:on_ready(function()
      server:setup(config)
    end)
  end
else
  lspconfig.sumneko_lua.setup(config)
end


vim.defer_fn(function()
  require("nvim-treesitter.install").update()("javascript")
end, 0)
