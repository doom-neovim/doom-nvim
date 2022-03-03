local rust = {}

rust.settings = {
}

rust.autocommands = {
  {
    "FileType",
    "rust",
    function()
      local langs_utils = require('doom.modules.langs.utils')
      
      langs_utils.use_lsp('rust_analyzer')
      
      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("rust")
      end, 0)
      
      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")
        langs_utils.use_null_ls_source({
          null_ls.builtins.formatting.rustfmt
        })
      end
    end,
    once = true,
  },
}

return rust
