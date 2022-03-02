local haskell = {}

haskell.settings = {
  language_server_name = 'hls',
}

haskell.autocommands = {
  {
    "FileType",
    "haskell",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.haskell.settings.language_server_name)
      
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.haskell = {
        install_info = {
          url = "https://github.com/tree-sitter/tree-sitter-haskell",
          files = {"src/parser.c", "src/scanner.c"}
        }
      }
      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("haskell")
      end, 0)

      -- Setup null-ls
      if doom.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.fouremolu
        })
      end

    end,
    once = true,
  },
}

return haskell
