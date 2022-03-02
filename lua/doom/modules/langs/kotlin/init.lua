local kotlin = {}

kotlin.settings = {
  language_server_name = 'kotlin_language_server',
}

kotlin.autocommands = {
  {
    "FileType",
    "kotlin",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.kotlin.settings.language_server_name)

      defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("kotlin")
      end, 0)
    end,
    once = true,
  },
}

return kotlin
