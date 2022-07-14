local bash = {}

bash.settings = {
  language_server_name = "bashls",
}

bash.autocmds = {
  {
    "BufWinEnter",
    "*.sh",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.bash.settings.language_server_name)

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("bash")
      end, 0)

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.shellcheck,
        })
      end
    end,
    once = true,
  },
}

return bash
