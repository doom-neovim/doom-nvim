local utils = require("doom.utils")

local typescript = {}

typescript.settings = {}

typescript.autocmds = {
  {
    "BufWinEnter",
    "*.js,*.jsx,*.ts,*.tsx",
    utils.make_run_once_function(function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp("tsserver")

      vim.defer_fn(function()
        local ts_install = require("nvim-treesitter.install")
        ts_install.ensure_installed("typescript", "javascript", "tsx")
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
        })
      end
    end),
    once = true,
  },
}

return typescript
