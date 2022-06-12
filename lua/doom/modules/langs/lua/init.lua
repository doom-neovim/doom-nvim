local lua = {}

lua.settings = {
  formatter = {
    enabled = true,
  },
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
        maxPreload = 1000,
        preloadFileSize = 150,
        checkThirdParty = false,
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
    commit = "f5c31936fe06fcbeb59b98f69f74f9c2f91abaec",
    ft = "lua",
  },
}

lua.autocmds = {
  {
    "BufWinEnter",
    "*.lua",
    function()
      local langs_utils = require("doom.modules.langs.utils")

      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      local config = vim.tbl_deep_extend(
        "force",
        doom.langs.lua.settings,
        require("lua-dev").setup(doom.langs.lua.settings.dev),
        {
          settings = {
            Lua = {
              runtime = {
                path = runtime_path,
              },
            },
          },
        }
      )

      langs_utils.use_lsp("sumneko_lua", {
        config = config,
      })

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("lua")
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.diagnostics.luacheck,
        })
      end
    end,
    once = true,
  },
}

return lua
