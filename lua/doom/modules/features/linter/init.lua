local linter = {}

linter.settings = {
  format_on_save = false,
}

linter.packages = {
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "3dbded7cfaf0591157280bc97d11407eeaef3ea9",
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
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
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
      vim.lsp.buf.formatting_sync()
    end,
    name = "Format/Fix",
  },
}

return linter
