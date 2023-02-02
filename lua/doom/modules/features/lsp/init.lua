local lsp = {}

--- Internal state of LSP module
-- Flag to enable/disable completions for <leader>tc keybind.
lsp.__completions_enabled = true

lsp.settings = {
  snippets = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  },
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
  severity_sort = true,
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
    experimental = {
      ghost_text = true,
    },
    completeopt = "menu,menuone,preview,noinsert",
    window = {
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
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
  sorting = {
    "offset",
    "exact",
    "score",
    "kind",
    "sort_text",
    "length",
    "order",
  },
}

lsp.packages = {
  ["nvim-lspconfig"] = {
    "neovim/nvim-lspconfig",
    commit = "ed88435764d8b00442e66d39ec3d9c360e560783",
  },
  ["nvim-cmp"] = {
    "hrsh7th/nvim-cmp",
    commit = "11a95792a5be0f5a40bab5fc5b670e5b1399a939",
    event = "InsertEnter",
    dependencies =  {
      "L3MON4D3/LuaSnip",
      commit = "53e812a6f51c9d567c98215733100f0169bcc20a",
    },
  },
  ["cmp-nvim-lua"] = {
    "hrsh7th/cmp-nvim-lua",
    commit = "f3491638d123cfd2c8048aefaf66d246ff250ca6",
    -- after = "nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    }
  },
  ["cmp-nvim-lsp"] = {
    "hrsh7th/cmp-nvim-lsp",
    -- after = "nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    }
  },
  ["cmp-path"] = {
    "hrsh7th/cmp-path",
    -- after = "nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    }
  },
  ["cmp-buffer"] = {
    "hrsh7th/cmp-buffer",
    commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
    -- after = "nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    }
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    commit = "18095520391186d634a0045dacaa346291096566",
    -- after = "nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    }
  },
  ["lsp_signature.nvim"] = {
    "ray-x/lsp_signature.nvim",
    commit = "1979f1118e2b38084e7c148f279eed6e9300a342",
    -- after = "nvim-lspconfig",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "VeryLazy",
  },
  ["cmp-cmdline"] = {
    "hrsh7th/cmp-cmdline",
    commit = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063",
    after = "nvim-cmp",
  },
}

lsp.configs = {}
lsp.configs["nvim-lspconfig"] = function()
  -- Lsp Symbols
  local signs = {
    Error = doom.features.lsp.settings.icons.error,
    Warn = doom.features.lsp.settings.icons.warn,
    Info = doom.features.lsp.settings.icons.info,
    Hint = doom.features.lsp.settings.icons.hint,
  }
  local hl = "DiagnosticSign"

  for severity, icon in pairs(signs) do
    local highlight = hl .. severity

    vim.fn.sign_define(highlight, {
      text = icon,
      texthl = highlight,
      numhl = highlight,
    })
  end

  vim.diagnostic.config({
    virtual_text = doom.features.lsp.settings.virtual_text,
    severity_sort = doom.features.lsp.settings.severity_sort,
    float = {
      show_header = false,
      border = "rounded",
    },
  })
  -- Border for lsp_popups
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = doom.border_style,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = doom.border_style,
  })
  -- symbols for autocomplete
  local kinds = {}
  for typ, icon in pairs(doom.features.lsp.settings.completion.kinds) do
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

  local cmp_ok, cmp = pcall(require, "cmp")
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if not cmp_ok or not luasnip_ok then
    return
  end
  luasnip.config.set_config(doom.features.lsp.settings.snippets)

  local replace_termcodes = utils.replace_termcodes

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

  -- Fetch the comparators from cmp
  local comparators = require("cmp.config.compare")
  doom.features.lsp.settings.sorting = vim.tbl_map(function(comparator)
    return comparators[comparator]
  end, doom.features.lsp.settings.sorting)

  cmp.setup(vim.tbl_deep_extend("force", doom.features.lsp.settings.completion, {
    completeopt = nil,
    completion = {
      completeopt = doom.features.lsp.settings.completion.completeopt,
    },
    formatting = {
      format = function(entry, item)
        item.kind =
          string.format("%s %s", doom.features.lsp.settings.completion.kinds[item.kind], item.kind)
        item.dup = vim.tbl_contains({ "path", "buffer" }, entry.source.name)
        return item
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      -- ["<ESC>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
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
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
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
    mapping = type(doom.features.lsp.settings.completion.mapping) == "function"
        and doom.features.lsp.settings.completion.mapping(cmp)
      or doom.features.lsp.settings.completion.mapping,
    enabled = function()
      return _doom.cmp_enable and vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    end,
  }))
end
lsp.configs["cmp-cmdline"] = function()
    local cmp = require("cmp")

    -- autocomplete for search
    cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- autocomplete for search
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
            { name = 'path' }
        },
        {
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' }
              }
            }
      })
    })

end
lsp.configs["lsp_signature.nvim"] = function()
  -- Signature help
  require("lsp_signature").setup(
    vim.tbl_deep_extend("force", doom.features.lsp.settings.signature, {
      handler_opts = {
        border = doom.border_style,
      },
    })
  )
end

lsp.binds = function()
  return {
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
        { "p>", vim.diagnostic.goto_prev, name = "Jump to prev diagnostic" },
        { "n>", vim.diagnostic.goto_next, name = "Jump to next diagnostic" },
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
                      border = doom.border_style,
                    })
                  end,
                  name = "Line",
                },
                { "l", vim.diagnostic.setloclist, name = "Loclist" },
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
                lsp.__completions_enabled = not lsp.__completions_enabled
                local bool2str = require("doom.utils").bool2str
                print(string.format("completion=%s", bool2str(lsp.__completions_enabled)))
              end,
              name = "Toggle completion",
            },
          },
        },
      },
    },
  }
end

return lsp
