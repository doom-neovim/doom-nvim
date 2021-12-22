local utils = require("doom.utils")
local is_plugin_disabled = utils.is_plugin_disabled

local binds = {
  { "K", vim.lsp.buf.hover, name = "Show hover doc" },
  { "[d", vim.diagnostic.goto_prev, name = "Jump to prev diagnostic" },
  { "]d", vim.diagnostic.goto_next, name = "Jump to next diagnostic" },
  {
    "g",
    {
      { "D", vim.lsp.buf.declaration, "Jump to declaration" },
      { "d", vim.lsp.buf.definition, name = "Jump to definition" },
      { "r", vim.lsp.buf.references, name = "Jump to references" },
      { "i", vim.lsp.buf.implementation, name = "Jump to implementation" },
      { "a", vim.lsp.buf.code_action, name = "Do code action" },
      { "d", vim.lsp.buf.hover, name = "Show hover doc" },
    },
  },
  {
    "<C-",
    {
      { "p>", vim.lsp.diagnostic.goto_prev, name = "Jump to prev diagnostic" },
      { "n>", vim.lsp.diagnostic.goto_next, name = "Jump to next diagnostic" },
      { "k>", vim.lsp.buf.signature_help, name = "Show signature help" },
    },
  },
}

if not is_plugin_disabled("whichkey") then
  table.insert(binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "c",
        name = "+code",
        {
          { "r", vim.lsp.buf.rename, name = "Rename" },
          { "a", vim.lsp.buf.code_action, name = "Do action" },
          { "t", vim.lsp.buf.type_definition, name = "Jump to type" },
          { "D", vim.lsp.buf.declaration, "Jump to declaration" },
          { "d", vim.lsp.buf.definition, name = "Jump to definition" },
          { "R", vim.lsp.buf.references, name = "Jump to references" },
          { "i", vim.lsp.buf.implementation, name = "Jump to implementation" },
          {
            "l",
            name = "+lsp",
            {
              { "i", "<cmd>LspInfo<CR>", name = "Inform" },
              { "r", "<cmd>LspRestart<CR>", name = "Restart" },
              { "s", "<cmd>LspStart<CR>", name = "Start" },
              { "d", "<cmd>LspStop<CR>", name = "Disconnect" },
            },
          },
          {
            "d",
            name = "+diagnostics",
            {
              { "[", vim.diagnostic.goto_prev, name = "Jump to prev" },
              { "]", vim.diagnostic.goto_next, name = "Jump to next" },
              { "p", vim.diagnostic.goto_prev, name = "Jump to prev" },
              { "n", vim.diagnostic.goto_next, name = "Jump to next" },
              {
                "L",
                function()
                  vim.lsp.diagnostic.show_line_diagnostics({
                    focusable = false,
                    border = doom.border_style,
                  })
                end,
                name = "Line",
              },
              { "l", vim.lsp.diagnostic.set_loclist, name = "Loclist" },
            },
          },
        },
      },
      {
        "t",
        name = "+tweak",
        {
          { "c", require("doom.core.functions").toggle_completion, name = "Toggle completion" },
        },
      },
    },
  })
end

return binds
