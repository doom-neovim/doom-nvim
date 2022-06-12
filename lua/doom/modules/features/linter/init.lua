local linter = {}

linter.settings = {
  format_on_save = false,
}

linter.packages = {
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "dfdd5fab3c53c30f83c78ea351b9a8f65715a5b7",
    after = "nvim-lspconfig",
  },
}

linter.configs = {}
linter.configs["null-ls.nvim"] = function()
  local null_ls = require("null-ls")

  null_ls.setup({
    on_attach = function(client)
      if
        client.server_capabilities.documentFormattingProvider
        and doom.features.linter.settings.format_on_save
      then
        vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua type(vim.lsp.buf.format) == "function" and vim.lsp.buf.format() or vim.lsp.buf.formatting_sync()
        augroup END
        ]])
      end
    end,
  })
end

linter.binds = {
  {
    "<leader>cf",
    function()
      if type(vim.lsp.buf.format) == "function" then
        vim.lsp.buf.format()
      else
        vim.lsp.buf.formatting_sync()
      end
    end,
    name = "Format/Fix",
  },
}

return linter
