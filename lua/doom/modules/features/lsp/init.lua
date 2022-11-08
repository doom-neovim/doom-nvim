local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.lsp
---@text # LSP / Code Completions
---
--- Adds code completions capabilities with nvim-cmp and nvim-lspconfig.
---
--- This module adds a number of code completion features to neovim.  It sets
--- up nvim-cmp with lsp, path, buffer, nvim and snippet sources and also adds
--- lsp signatures to show function signatures as you type.  This module does
--- not setup any language LSPs, those are configured within the language modules.
--- Instead this module setups and configures nvim-cmp and other plugins that are
--- shared by language modules.
---
--- ## Adding extra nvim-cmp sources
---
--- To add extra completion sources to nvim-cmp you will first need to install
--- the nvim-cmp extension in your `config.lua` file.  You will then need to
--- add the source to the settings table of this module.  Here's an example
--- using cmp-calc.
---
--- ```lua
--- -- config.lua
--- doom.use_package("hrsh7th/cmp-calc")
--- local lsp_settings = doom.features.lsp.settings
--- table.insert(lsp_settings.completion.sources, { name = 'calc' })
--- ```
---
--- If you want to add a source that needs access to nvim-cmp.  I.e `cmp-nvim-lsp-document-symbol`
--- you will need to use the `on_post_config` hook of the packages field of the `lsp`
--- module.
---
--- ```lua
--- -- config.lua
--- doom.use_package({ "hrsh7th/cmp-nvim-lsp-document-symbol", after="nvim-cmp" })
--- doom.features.lsp.packages["nvim-cmp"].on_post_config(function()
---   local cmp = require'cmp'
---   cmp.setup.cmdline('/', {
---     sources = cmp.config.sources({
---       { name = 'nvim_lsp_document_symbol' }
---     }, {
---       { name = 'buffer' }
---     })
---   })
--- end)
--- ```
---
--- > 💡 You will have reload doom-nvim and run `:PackerCompile` after adding pre/post config hooks.
---
--- > 💡 Some cmp completion sources do not work well with lazy loading.
--- > You may have to disable lazy loading so it works properly.
--- > ```lua
--- > doom.features.lsp.packages['nvim-cmp'].event = nil -- Removes the load on InsertEnter autocommand
--- > ```
local lsp = DoomModule.new("lsp")


---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.lsp")
lsp.settings = {
  -- Settings for cmp_luasnip
  snippets = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  },
  -- Settings for "lsp_signature.nvim"
  signature = {
    -- This is mandatory, otherwise border config won't get registered.
    -- If you want to hook lspsaga or other signature handler, pls set to false
    bind = true,
    -- Show hint in a floating window
    floating_window = false,
    -- Position floating window above or below cursor
    floating_window_above_cur_line = true,
    -- Number of comment/doc lines when inserting text (when `floating_window = true`)
    doc_lines = 10,
    -- When true, keep floating window open until all parameters completed
    fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = true, -- virtual hint enable
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "Search", -- how your parameter will be highlight
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    transparency = 100,
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
  -- Settings for nvim-cmp
  completion = {
    -- Icons for each completion type
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
      -- Show current completion as ghost text in line
      -- @type boolean
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

---@eval return doom.core.doc_gen.generate_packages_documentation("features.lsp")
lsp.packages = {
  ["nvim-lspconfig"] = {
    "neovim/nvim-lspconfig",
    commit = "334cc8601ce5f04384ebe79527284fd177938412",
    module = "lspconfig",
  },
  ["nvim-cmp"] = {
    "hrsh7th/nvim-cmp",
    commit = "0e436ee23abc6c3fe5f3600145d2a413703e7272",
    event = "InsertEnter",
    requires = {
      "L3MON4D3/LuaSnip",
      commit = "53e812a6f51c9d567c98215733100f0169bcc20a",
      module = "luasnip",
    },
  },
  ["cmp-nvim-lua"] = {
    "hrsh7th/cmp-nvim-lua",
    commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21",
    after = "nvim-cmp",
  },
  ["cmp-nvim-lsp"] = {
    "hrsh7th/cmp-nvim-lsp",
    commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8",
    after = "nvim-cmp",
  },
  ["cmp-path"] = {
    "hrsh7th/cmp-path",
    commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
    after = "nvim-cmp",
  },
  ["cmp-buffer"] = {
    "hrsh7th/cmp-buffer",
    commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
    after = "nvim-cmp",
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36",
    after = "nvim-cmp",
  },
  ["lsp_signature.nvim"] = {
    "ray-x/lsp_signature.nvim",
    commit = "e65a63858771db3f086c8d904ff5f80705fd962b",
    after = "nvim-lspconfig",
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

-- Internal state of LSP module
-- Flag to enable/disable completions for <leader>tc keybind.
lsp.__completions_enabled = true

---@eval return doom.core.doc_gen.generate_keybind_documentation("features.lsp")
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
