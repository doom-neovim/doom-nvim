return function()
  local fn = vim.fn
  local lsp = vim.lsp
  local config = require("doom.core.config").config

  -- Lsp Symbols
  fn.sign_define("DiagnosticSignError", {
    texthl = "DiagnosticSignError",
    text = config.doom.lsp_error,
    numhl = "DiagnosticSignError",
  })
  fn.sign_define("DiagnosticSignWarn", {
    texthl = "DiagnosticSignWarn",
    text = config.doom.lsp_warning,
    numhl = "DiagnosticSignWarn",
  })
  fn.sign_define("DiagnosticSignHint", {
    texthl = "DiagnosticSignHint",
    text = config.doom.lsp_hint,
    numhl = "DiagnosticSignHint",
  })
  fn.sign_define("DiagnosticSignInfo", {
    texthl = "DiagnosticSignInfo",
    text = config.doom.lsp_information,
    numhl = "DiagnosticSignInfo",
  })

  lsp.handlers["textDocument/publishDiagnostics"] =
    lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
        prefix = config.doom.lsp_virtual_text, -- change this to whatever you want your diagnostic icons to be
      },
    })
  -- symbols for autocomplete
  lsp.protocol.CompletionItemKind = {
    "   (Text) ",
    "   (Method)",
    "   (Function)",
    "   (Constructor)",
    " ﴲ  (Field)",
    "   (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " ﰠ  (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    "   (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    " ﲀ  (Constant)",
    " ﳤ  (Struct)",
    "   (Event)",
    "   (Operator)",
    "   (TypeParameter)",
  }

  -- suppress error messages from lang servers
  vim.notify = function(msg, log_level, _opts)
    if msg:match("exit code") then
      return
    end
    if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end
end
