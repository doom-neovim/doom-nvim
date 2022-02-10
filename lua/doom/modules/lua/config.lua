local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled
local langs_utils = require('doom.modules.langs_utils')

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

langs_utils.use_lsp('sumneko_lua', {
  config = config,
})

vim.defer_fn(function()
  require("nvim-treesitter.install").ensure_installed("lua")
end, 0)

-- Setup null-ls
if doom.linter then
  local null_ls = require("null-ls")

  langs_utils.use_null_ls_source({
    null_ls.builtins.formatting.stylua,
  })
end
