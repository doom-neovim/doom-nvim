local autocmds = {}

if doom.lsp.hint_enable then
  local show_diagnostics_function = function()
    vim.diagnostic.open_float(nil, { focus = false, border = doom.border_style })
  end
  if vim.fn.has("nvim-0.6.0") ~= 1 then
    show_diagnostics_function = function()
      vim.lsp.diagnostic.show_line_diagnostics({ focusable = false, border = doom.border_style })
    end
  end
  table.insert(autocmds, {
    "CursorHold,CursorHoldI",
    "<buffer>",
    show_diagnostics_function,
  })
end

return autocmds
