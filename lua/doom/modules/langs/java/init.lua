local java = {}

java.settings = {
  language_server_name = "jdtls",
}

java.autocmds = {
  {
    "BufWinEnter",
    "*.java",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.java.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("java")

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.google_java_format,
        })
      end
    end,
    once = true,
  },
}

return java
