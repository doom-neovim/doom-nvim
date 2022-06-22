return function()
  local fn = vim.fn
  local lsp = vim.lsp
  local config = require("doom.core.config").config

  -- Lsp Symbols
  local signs, hl
  if vim.fn.has("nvim-0.6.0") == 1 then
    signs = {
      Error = config.doom.lsp_error,
      Warn = config.doom.lsp_warn,
      Info = config.doom.lsp_info,
      Hint = config.doom.lsp_hint,
    }
    hl = "DiagnosticSign"
  else
    signs = {
      Error = config.doom.lsp_error,
      Warning = config.doom.lsp_warn,
      Information = config.doom.lsp_info,
      Hint = config.doom.lsp_hint,
    }
    hl = "LspDiagnosticsSign"
  end

  for severity, icon in pairs(signs) do
    local highlight = hl .. severity

    fn.sign_define(highlight, {
      text = icon,
      texthl = highlight,
      numhl = highlight,
    })
  end

  lsp.handlers["textDocument/publishDiagnostics"] =
    lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = config.doom.enable_lsp_virtual_text and {
        prefix = config.doom.lsp_virtual_text, -- change this to whatever you want your diagnostic icons to be
      } or false,
    })
  -- Border for lsp_popups
  lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
  })
  lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
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
