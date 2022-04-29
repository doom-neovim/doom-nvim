local go = {}

go.settings = {
  language_server_name = 'gopls',
}

go.autocmds = {
  {
    "BufWinEnter",
    "*.go",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.go.settings.language_server_name)

      defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("go")
      end, 0)
      --
      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.golangci_lint
        })
      end

    end,
    once = true,
  },
}

return go
