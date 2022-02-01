local autocmds = {}
if doom.linter.lint_on_save then
  table.insert(autocmds, {
    "BufWritePre",
    "<buffer>",
    function()
      vim.lsp.buf.formatting_sync()
    end,
  })
end

return autocmds
