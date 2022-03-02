local linter = {}

linter.settings = {
  format_on_save = true,
}

linter.packages = {
  ["null-ls.nvim"] = {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "a1804de23ce354c982aa08c57d3ed89aad8a15a9",
    after = 'nvim-lspconfig',
  },
}


linter.configure_functions = {}
linter.configure_functions["null-ls.nvim"] = function()
  local null_ls = require("null-ls")

  null_ls.setup({
    on_attach = on_attach,
  })
end

linter.binds = {
  { '<leader>cf', function() vim.lsp.buf.formatting_sync() end, name = 'Format/Fix' },
}

linter.autocommands = function ()
  local autocmds = {}
  
  if doom.linter.format_on_save then
    table.insert(autocmds, {
      "BufWritePre",
      "<buffer>",
      function()
        vim.lsp.buf.formatting_sync()
      end,
    })
  end

  return autocmds

end


return linter
