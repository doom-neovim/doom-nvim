local tailwindcss = {}

tailwindcss.settings = {
}

tailwindcss.autocommands = {
  {
    "FileType",
    "css,scss,vue,html",
    function()
      local langs_utils = require('doom.modules.langs.utils')

      langs_utils.use_lsp('tailwindcss')

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("css")
      end, 0)

      -- Setup null-ls
      if doom.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.rustywind
        })
      end

    end,
    once = true,
  },
}

return tailwindcss
