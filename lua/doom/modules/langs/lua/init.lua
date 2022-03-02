local lua = {}

lua.settings = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "doom" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
  dev = {
    library = {
      vimruntime = true,
      types = true,
      plugins = true,
    },
  },
}

lua.packages = {
  ["lua-dev.nvim"] = {
    "folke/lua-dev.nvim",
    commit = "a0ee77789d9948adce64d98700cc90cecaef88d5",
    ft = "lua",
  },
}

lua.configure_functions = {}
lua.configure_functions["lua-dev.nvim"] = function()
  require("lua-dev").setup(doom.modules.lua.settings.dev)
end

lua.autocommands = {
  {
    "FileType",
    "lua",
    function()
      local utils = require("doom.utils")
      local is_plugin_disabled = utils.is_plugin_disabled
      local langs_utils = require('doom.modules.langs.utils')

      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      local config = vim.tbl_deep_extend("force", doom.modules.lua.settings, {
        settings = {
          Lua = {
            runtime = {
              path = runtime_path,
            },
          },
        },
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
    end,
    once = true,
  },
}

return lua
