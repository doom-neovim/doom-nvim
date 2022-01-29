local linter = {}

linter.defaults = {
  format_on_save = false,
}

linter.packer_config = {}
linter.packer_config["null-ls.nvim"] = function()
  local on_attach = not doom.linter.format_on_save and nil or function(client)
      if client.resolved_capabilities.document_formatting then
        vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
        ]])
      end
    end

  local null_ls = require('null-ls')

  null_ls.setup({
    on_attach = on_attach,
  })
end

return linter
