---[[-----------------]]---
--    LSP Keybindings    --
---]]-----------------[[---

local utils = require("doom.utils")
local check_plugin = require("doom.core.functions").check_plugin

local opts = { silent = true }
local lsp_opts = vim.tbl_extend("force", opts, { expr = true })

-- If the LSP is not disabled and compe is installed then set its mappings.
if check_plugin("nvim-compe", "opt") then
  -- https://github.com/hrsh7th/nvim-compe#mappings
  utils.map(
    "i",
    "<C-Space>",
    "compe#complete()",
    lsp_opts,
    "Completion",
    "compe_complete",
    "Complete"
  )
  utils.map(
    "i",
    "<CR>",
    'compe#confirm("<CR>")',
    lsp_opts,
    "Completion",
    "compe_confirm",
    "Confirm completion"
  )
  utils.map(
    "i",
    "<C-e>",
    'compe#close("<C-e>")',
    lsp_opts,
    "Completion",
    "compe_close",
    "Close compe menu"
  )
  utils.map(
    "i",
    "<C-f>",
    'compe#scroll({ "delta": +4 })',
    lsp_opts,
    "Completion",
    "compe_indent",
    "Indent current line"
  )
  utils.map(
    "i",
    "<C-d>",
    'compe#scroll({ "delta": -4 })',
    lsp_opts,
    "Completion",
    "compe_dedent",
    "Dedent current line"
  )
  -- gd: jump to definition
  utils.map(
    "n",
    "gd",
    ":lua vim.lsp.buf.definition()<CR>",
    opts,
    "LSP",
    "jump_to_definition",
    "Jump to definition"
  )
  -- gr: go to reference
  utils.map(
    "n",
    "gr",
    ":lua vim.lsp.buf.references()<CR>",
    opts,
    "LSP",
    "goto_reference",
    "Goto reference"
  )
  -- gi: buf implementation
  utils.map(
    "n",
    "gi",
    ":lua vim.lsp.buf.implementation()<CR>",
    opts,
    "LSP",
    "goto_implementation",
    "List implementations"
  )
  -- ca: code actions
  utils.map(
    "n",
    "ca",
    ":lua vim.lsp.buf.code_action()<CR>",
    opts,
    "LSP",
    "code_action",
    "Code action"
  )
  -- K: hover doc
  utils.map(
    "n",
    "K",
    ":lua vim.lsp.buf.hover()<CR>",
    opts,
    "LSP",
    "hover_doc",
    "Hover documentation"
  )
  -- Control+p: Jump to previous diagnostic
  utils.map(
    "n",
    "<C-p>",
    ":lua vim.lsp.diagnostic.goto_prev()<CR>",
    opts,
    "LSP",
    "prev_diagnostic",
    "Jump to previous diagnostic"
  )
  -- Control+n: Jump to next diagnostic
  utils.map(
    "n",
    "<C-n>",
    ":lua vim.lsp.diagnostic.goto_next()<CR>",
    opts,
    "LSP",
    "next_diagnostic",
    "Jump to next diagnostic"
  )

  vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')
end

-- LuaSnip mappings
if check_plugin("LuaSnip", "opt") then
  utils.map(
    "n",
    "<Tab>",
    'luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"',
    lsp_opts,
    "Snippets",
    "luasnip_expand",
    "Expand snippet"
  )
  utils.map(
    "i",
    "<S-Tab>",
    '<cmd>lua require("luasnip").jump(-1)<CR>',
    opts,
    "Snippets",
    "luasnip_prev_sel",
    "Previous snippet"
  )

  utils.map(
    "s",
    "<Tab>",
    '<cmd>lua require("luasnip").jump(1)<CR>',
    opts,
    "Snippets",
    "luasnip_next_sel",
    "Next snippet"
  )
  utils.map(
    "s",
    "<S-Tab>",
    '<cmd>lua require("luasnip").jump(-1)<CR>',
    opts,
    "Snippets",
    "luasnip_prev_sel_s",
    "Previous snippet (Select mode)"
  )

  utils.map(
    "i",
    "<C-E>",
    'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"',
    lsp_opts,
    "Snippets",
    "luasnip_next_choice",
    "Next snippets field"
  )
  utils.map(
    "s",
    "<C-E>",
    'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"',
    lsp_opts,
    "Snippets",
    "luasnip_next_choice_s",
    "Next snippet field"
  )
end
