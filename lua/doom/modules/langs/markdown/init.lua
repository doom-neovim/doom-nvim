local markdown = {}

markdown.settings = {
}

markdown.autocmds = {
  {
    "FileType",
    "markdown",
    function()
      local langs_utils = require("doom.modules.langs.utils")

      langs_utils.use_lsp("remark_ls")

      vim.defer_fn(function()
        require("nvim-treesitter.install").ensure_installed("markdown")
      end, 0)

      -- Setup null-ls
      if doom.modules.linter then
        local null_ls = require("null-ls")

        langs_utils.use_null_ls_source({
          null_ls.builtins.diagnostics.markdownlint,
        })
      end
    end,
    once = true,
  },
}

return markdown
