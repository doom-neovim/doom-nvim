local lsp = {}

lsp.settings = {
  signature = {
    bind = true,
    doc_lines = 10,
    floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true,
    fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = true, -- virtual hint enable
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "Search", -- how your parameter will be highlight
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    transparency = 80,
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    debug = false, -- set to true to enable debug logging
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  },
  icons = {
    error = "",
    warn = "",
    hint = "",
    info = "",
  },
  virtual_text = {
    prefix = " ",
  },
  completion = {
    kinds = {
      Text = " ",
      Method = " ",
      Function = " ",
      Constructor = " ",
      Field = "ﴲ ",
      Variable = " ",
      Class = " ",
      Interface = "ﰮ ",
      Module = " ",
      Property = "ﰠ ",
      Unit = " ",
      Value = " ",
      Enum = "練",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = " ",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = "ﲀ ",
      Struct = "ﳤ ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    },
    completeopt = "menu,menuone,preview,noinsert",
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer" },
    },
  },
}

-- https://github.com/nvim-lua/lsp-status.nvim
-- https://github.com/onsails/lspkind-nvim
local is_module_enabled = require("doom.utils").is_module_enabled
lsp.packages = {
  ["nvim-lspconfig"] = {
    "neovim/nvim-lspconfig",
    commit = "63efd6ed156ae578c7e23278ec0a82776802106b",
    module = "lspconfig",
  },
  ["nvim-cmp"] = {
    "hrsh7th/nvim-cmp",
    commit = "272cbdca3e327bf43e8df85c6f4f00921656c4e4",
    after = is_module_enabled("snippets") and "LuaSnip" or nil,
  },
  ["cmp-nvim-lua"] = {
    "hrsh7th/cmp-nvim-lua",
    commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21",
    after = "nvim-cmp",
  },
  ["cmp-nvim-lsp"] = {
    "hrsh7th/cmp-nvim-lsp",
    commit = "ebdfc204afb87f15ce3d3d3f5df0b8181443b5ba",
    after = "nvim-cmp",
  },
  ["cmp-path"] = {
    "hrsh7th/cmp-path",
    commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e",
    after = "nvim-cmp",
  },
  ["cmp-buffer"] = {
    "hrsh7th/cmp-buffer",
    commit = "d66c4c2d376e5be99db68d2362cd94d250987525",
    after = "nvim-cmp",
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    commit = "d6f837f4e8fe48eeae288e638691b91b97d1737f",
    after = "nvim-cmp",
    disabled = not is_module_enabled("snippets"),
  },
  ["lsp_signature.nvim"] = {
    "ray-x/lsp_signature.nvim",
    commit = "e4f7dad45a1a3bb390977b4e69a528993bcefeac",
    after = "nvim-lspconfig",
  },
}

lsp.configs = {}
lsp.configs["nvim-lspconfig"] = function()
  -- Lsp Symbols
  local signs, hl
  if vim.fn.has("nvim-0.6.0") == 1 then
    signs = {
      Error = doom.modules.lsp.settings.icons.error,
      Warn = doom.modules.lsp.settings.icons.warn,
      Info = doom.modules.lsp.settings.icons.info,
      Hint = doom.modules.lsp.settings.icons.hint,
    }
    hl = "DiagnosticSign"
  else
    signs = {
      Error = doom.modules.lsp.settings.icons.error,
      Warning = doom.modules.lsp.settings.icons.warn,
      Information = doom.modules.lsp.settings.icons.info,
      Hint = doom.modules.lsp.settings.icons.hint,
    }
    hl = "LspDiagnosticsSign"
  end

  for severity, icon in pairs(signs) do
    local highlight = hl .. severity

    vim.fn.sign_define(highlight, {
      text = icon,
      texthl = highlight,
      numhl = highlight,
    })
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = doom.modules.lsp.settings.virtual_text,
    }
  )
  -- Border for lsp_popups
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = doom.settings.border_style,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = doom.settings.border_style,
  })
  -- symbols for autocomplete
  local kinds = {}
  for typ, icon in pairs(doom.modules.lsp.settings.completion.kinds) do
    table.insert(kinds, " " .. icon .. " (" .. typ .. ") ")
  end
  vim.lsp.protocol.CompletionItemKind = kinds

  -- suppress error messages from lang servers
  vim.notify = function(msg, log_level, _)
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
lsp.configs["nvim-cmp"] = function()
  local utils = require("doom.utils")
  local snippets_enabled = utils.is_module_enabled("snippets")

  local cmp = require("cmp")
  local luasnip = snippets_enabled and require("luasnip")
  local replace_termcodes = utils.replace_termcodes

  local source_map = {
    nvim_lsp = "[LSP]",
    luasnip = "[Snp]",
    buffer = "[Buf]",
    nvim_lua = "[Lua]",
    path = "[Path]",
  }

  --- Helper function to check what <Tab> behaviour to use
  --- @return boolean
  local function check_backspace()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  -- Initalize the cmp toggle if it doesn't exist.
  if _doom.cmp_enable == nil then
    _doom.cmp_enable = true
  end

  cmp.setup(vim.tbl_deep_extend("force", doom.modules.lsp.settings.completion, {
    completeopt = nil,
    completion = {
      completeopt = doom.modules.lsp.settings.completion.completeopt,
    },
    formatting = {
      format = function(entry, item)
        item.kind = string.format(
          "%s %s",
          doom.modules.lsp.settings.completion.kinds[item.kind],
          item.kind
        )
        item.menu = source_map[entry.source.name]
        item.dup = vim.tbl_contains({ "path", "buffer" }, entry.source.name)
        return item
      end,
    },
    -- TODO: move binds into `doom.settings.cmp_binds = {}`
    -- 		so that one can easilly change these without having to mess with core.
    mapping = {
      doom.settings.cmp_binds.select_prev_item = cmp.mapping.select_prev_item(),
      doom.settings.cmp_binds.select_next_item = cmp.mapping.select_next_item(),
      doom.settings.cmp_binds.scroll_docs_bkw = cmp.mapping.scroll_docs(-4),
      doom.settings.cmp_binds.scroll_docs_fwd = cmp.mapping.scroll_docs(4),
      doom.settings.cmp_binds.complete = cmp.mapping.complete(),
      doom.settings.cmp_binds.close = cmp.mapping.close(),
      -- ["<ESC>"] = cmp.mapping.close(),
      doom.settings.cmp_binds.confirm = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      doom.settings.cmp_binds.tab = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snippets_enabled and luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(replace_termcodes("<Plug>luasnip-expand-or-jump"), "")
        elseif check_backspace() then
          vim.fn.feedkeys(replace_termcodes("<Tab>"), "n")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      doom.settings.cmp_binds.stab = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snippets_enabled and luasnip.jumpable(-1) then
          vim.fn.feedkeys(replace_termcodes("<Plug>luasnip-jump-prev"), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
  }, {
    mapping = type(doom.modules.lsp.settings.completion.mapping) == "function"
        and doom.modules.lsp.settings.completion.mapping(cmp)
      or doom.modules.lsp.settings.completion.mapping,
    enabled = function()
      return _doom.cmp_enable and vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    end,
  }))
end
lsp.configs["lsp_signature.nvim"] = function()
  -- Signature help
  require("lsp_signature").setup(vim.tbl_deep_extend("force", doom.modules.lsp.settings.signature, {
    handler_opts = {
      border = doom.settings.border_style,
    },
  }))
end

-- local lsp_opts = vim.tbl_extend("force", opts.sf, { expr = true })
--
-- bind({ -- lsp
--   not enabled,
--   lsp = {
--     "<c-n>",
--     'luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"',
--     "luasnip_expand",
--     options = lsp_opts,
--   },
--   --     "s", "<c-n>", 'luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"', lsp_opts, "luasnip_expand",
--   --     "s", "<c-p>", 'luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"', lsp_opts, "luasnip_expand",
--   --     "s", "<c-k>", '<cmd>lua require("luasnip").jump(1)<CR>', opts, "luasnip_next_sel_s",
--   --     "s", "<c-j>", '<cmd>lua require("luasnip").jump(-1)<CR>', opts, "luasnip_prev_sel_s",
--   --     "i", "<c-k>", '<cmd>lua require("luasnip").jump(1)<CR>', opts, "luasnip_next_sel_i_insert",
--   --     "i", "<c-j>", '<cmd>lua require("luasnip").jump(-1)<CR>', opts, "luasnip_prev_sel_i_insert",
--   --     "i", "<C-E>", 'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"', lsp_opts, "luasnip_next_choice",
--   --     "s", "<C-E>", 'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"', lsp_opts, "luasnip_next_choice_s",
-- })
--

lsp.binds = {
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
  {
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
                  vim.diagnostic.open_float(0, {
                    focusable = false,
                    border = doom.settings.border_style,
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
          {
            "c",
            function()
              require("doom.core.functions").toggle_completion()
            end,
            name = "Toggle completion",
          },
        },
      },
    },
  },
}

return lsp
