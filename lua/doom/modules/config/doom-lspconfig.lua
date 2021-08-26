return function()
  local fn = vim.fn
  local lsp = vim.lsp
  local config = require("doom.core.config").load_config()

  -- Snippets support
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- Lsp Symbols
  fn.sign_define("LspDiagnosticsSignError", {
    texthl = "LspDiagnosticsSignError",
    text = config.doom.lsp_error,
    numhl = "LspDiagnosticsSignError",
  })
  fn.sign_define("LspDiagnosticsSignWarning", {
    texthl = "LspDiagnosticsSignWarning",
    text = config.doom.lsp_warning,
    numhl = "LspDiagnosticsSignWarning",
  })
  fn.sign_define("LspDiagnosticsSignHint", {
    texthl = "LspDiagnosticsSignHint",
    text = config.doom.lsp_hint,
    numhl = "LspDiagnosticsSignHint",
  })
  fn.sign_define("LspDiagnosticsSignInformation", {
    texthl = "LspDiagnosticsSignInformation",
    text = config.doom.lsp_information,
    numhl = "LspDiagnosticsSignInformation",
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
    "   (Constructor)",
    " ﴲ  (Field)",
    "[] (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " 襁 (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    "   (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    " ﲀ  (Constant)",
    " ﳤ  (Struct)",
    "   (Event)",
    "   (Operator)",
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
