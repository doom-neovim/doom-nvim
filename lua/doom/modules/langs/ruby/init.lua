local ruby = {}

ruby.settings = {
  language_server_name = "solargraph",
}

ruby.autocmds = {
  {
    "BufWinEnter",
    "*.rb",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.ruby.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("ruby")

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.rubocop,
        })
      end
    end,
    once = true,
  },
}

return ruby
