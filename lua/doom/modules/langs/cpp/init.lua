local utils = require('doom.utils')
local cpp = {}

cpp.settings = {
  language_server_name = utils.get_sysname() == 'Darwin' and 'clangd' or 'ccls',
}

cpp.autocommands = {
  {
    "FileType",
    "cpp",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      langs_utils.use_lsp(doom.modules.cpp.settings.language_server_name)
      
      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("cpp", "c")
      end, 0)

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.cppcheck,
          null_ls.builtins.formatting.clang_format
        })
      end

    end,
    once = true,
  },
}

return cpp
