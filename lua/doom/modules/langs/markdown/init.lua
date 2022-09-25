local markdown = {}

markdown.settings = {
  disable_treesitter = false,
}

markdown.autocmds = {
  {
    "FileType",
    "markdown",
    function()
      -- local langs_utils = require("doom.modules.langs.utils")

      -- Disabled due to unreliability (only works in projects with `remark`
      -- npm package installed).
      -- langs_utils.use_lsp("remark_ls")

      vim.defer_fn(function()
        if not markdown.settings.disable_treesitter then
          require("nvim-treesitter.install").ensure_installed("markdown")
        end
      end, 0)

      -- Setup null-ls
      -- Disabled due to lsp being disabled. null-ls gets triggered by lspconfig
      -- if doom.modules.linter then
      --   local null_ls = require("null-ls")
      --
      --   langs_utils.use_null_ls_source({
      --     null_ls.builtins.diagnostics.markdownlint,
      --   })
      -- end
    end,
    once = true,
  },
}

return markdown
