local kotlin = {}

kotlin.settings = {
  language_server_name = "kotlin_language_server",
}

kotlin.autocmds = {
  {
    "BufWinEnter",
    "*.kt,*.kts",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.kotlin.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("kotlin")
      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.ktlint,
        })
      end
    end,
    once = true,
  },
}

return kotlin
