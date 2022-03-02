local css = {}

css.settings = {
  language_server_name = 'cssls',
}

css.autocommands = {
  {
    "BufNewFile,BufRead",
    "*.css,*.scss,*.vue",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.css.settings.language_server_name)
      
      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("css")
      end, 0)
      
      -- Setup null-ls
      if doom.linter then
        local null_ls = require("null-ls")
      
        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.formatting.stylelint,
        })
      end
    end,
    once = true,
  },
}

return css
