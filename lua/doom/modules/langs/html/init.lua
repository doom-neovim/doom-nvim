local utils = require("doom.utils")

local html = {}

html.settings = {}

html.autocmds = {
  {
    "BufWinEnter",
    "*.html",
    utils.make_run_once_function(function()
      print("html")
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp("html")

      vim.defer_fn(function()
        local ts_install = require("nvim-treesitter.install")
        ts_install.ensure_installed("html", "javascript", "css")
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.tidy,
        })
      end
    end),
    once = true,
  },
}

return html
