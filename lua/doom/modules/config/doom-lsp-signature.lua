return function()
  -- Signature help
  require("lsp_signature").setup({
    bind = true,
    floating_window = true,
    floating_window_above_cur_line = true,
    handler_opts = {
      border = "single",
    },
  })
end
