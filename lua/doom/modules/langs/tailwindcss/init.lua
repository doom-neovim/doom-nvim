local utils = require("doom.utils")

local tailwindcss = {}

tailwindcss.settings = {}

tailwindcss.autocmds = {
  {
    "BufWinEnter",
    "*.css,*.scss,*.vue,*.html,*.svelte,*.jsx,*.tsx",
    utils.make_run_once_function(function()
      local langs_utils = require("doom.modules.langs.utils")

      langs_utils.use_lsp("tailwindcss")

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("css")
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.rustywind,
        })
      end
    end),
    once = true,
  },
}

return tailwindcss
