local bash = {}

bash.settings = {
  language_server_name = 'bashls',
}

bash.autocommands = {
  {
    "FileType",
    "sh",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.bash.settings.language_server_name)
      
      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("bash")
      end, 0)

      -- Setup null-ls
      if doom.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.shfmt
        })
      end

    end,
    once = true,
  },
}

return bash
