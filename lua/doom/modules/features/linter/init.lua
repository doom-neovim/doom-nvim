local linter = {}

linter.settings = {
  format_on_save = false,
}

linter.packages = {
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "a1804de23ce354c982aa08c57d3ed89aad8a15a9",
    after = "nvim-lspconfig",
  },
}

linter.configure_functions = {}
linter.configure_functions["null-ls.nvim"] = function()
  local null_ls = require("null-ls")

  null_ls.setup({
    on_attach = function(client)
      if
        client.resolved_capabilities.document_formatting
        and doom.modules.linter.settings.format_on_save
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
