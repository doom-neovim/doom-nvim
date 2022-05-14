local utils = require("doom.utils")
local cc = {}

cc.settings = {
  language_server_name = utils.get_sysname() == "Darwin" and "clangd" or "ccls",
}

cc.autocmds = {
  {
    "BufWinEnter",
    "*.cpp,*.cc,*.cxx,*.c,*.hpp,*.hh,*.hxx,*.h",
    function()
      local langs_utils = require("doom.modules.langs.utils")
      langs_utils.use_lsp(doom.langs.cc.settings.language_server_name)

      require("nvim-treesitter.install").ensure_installed("cpp", "c")

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.cppcheck,
          null_ls.builtins.formatting.clang_format,
        })
      end
    end,
    once = true,
  },
}

return cc
