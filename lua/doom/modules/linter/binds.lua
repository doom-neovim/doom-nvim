return {
  { '<leader>cf', function() vim.lsp.buf.formatting_sync() end, name = 'Format/Fix' },
}
