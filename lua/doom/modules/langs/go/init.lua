local go = {}

go.settings = {
  language_server_name = "gopls",
}

go.autocmds = {
  {
    "BufWinEnter",
    "*.go",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.go.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("go")

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.golangci_lint,
        })
      end
    end,
    once = true,
  },
}

return go
