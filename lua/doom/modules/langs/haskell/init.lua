local haskell = {}

haskell.settings = {
  language_server_name = "hls",
}

haskell.autocmds = {
  {
    "BufWinEnter",
    "*.hs",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.haskell.settings.language_server_name)

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.haskell = {
        install_info = {
          url = "https://github.com/tree-sitter/tree-sitter-haskell",
          files = { "src/parser.c", "src/scanner.c" },
        },
      }
      require("nvim-treesitter.install").ensure_installed("haskell")

      -- Setup null-ls
      if doom.features.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.fouremolu,
        })
      end
    end,
    once = true,
  },
}

return haskell
