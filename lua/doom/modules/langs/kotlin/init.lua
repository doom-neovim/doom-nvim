local kotlin = {}

kotlin.settings = {
  language_server_name = 'kotlin_language_server',
}

kotlin.autocmds = {
  {
    "BufWinEnter",
    "*.kt",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.langs.kotlin.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("kotlin")
    end,
    once = true,
  },
}

return kotlin
