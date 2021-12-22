local autocmds = {}

if doom.lsp.hint_enable then
  local show_diagnostics_function = (
    "vim.diagnostic.open_float(nil, { focus = false, border = %s })"
  ):format(doom.border_style)
  if vim.fn.has("nvim-0.6.0") ~= 1 then
    show_diagnostics_function =
      'vim.lsp.diagnostic.show_line_diagnostics({ focusable = false, border = "single" })'
  end
  table.insert(autocmds, {
    "CursorHold,CursorHoldI",
    "<buffer>",
    ("lua %s"):format(show_diagnostics_function),
  })
end

return autocmds
