local svelte = {}

svelte.settings = {
  language_server_name = 'svelte',
}

svelte.autocmds = {
  {
    "FileType",
    "svelte",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.svelte.settings.language_server_name)

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("svelte")
      end, 0)

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
        })
      end
    end,
    once = true,
  },
}

return svelte
