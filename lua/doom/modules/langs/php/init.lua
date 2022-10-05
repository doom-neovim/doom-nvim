local php = {}

php.settings = {
  language_server_name = "intelephense",
}

php.autocmds = {
  {
    "BufWinEnter",
    "*.php,*.phtml",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.php.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("php")

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.diagnostics.phpstan,
        })
      end
    end,
    once = true,
  },
}

return php
