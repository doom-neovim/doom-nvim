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
  dont_install = {},
  servers = {
    lua = { "sumneko_lua" },
    ansible = { "ansiblels" },
    angular = { "angularls" },
    bash = { "bashls" },
    c_sharp = { "omnisharp" },
    c = { "clangd" },
    cpp = { "clangd" },
    cmake = { "cmake" },
    css = { "cssls" },
    clojure = { "clojure_lsp" },
    dockerfile = { "dockerls" },
    dot = { "dotls" },
    elixer = { "elixerls" },
    elm = { "elmls" },
    ember = { "ember" },
    fortran = { "fortls" },
    go = { "gopls" },
    graphql = { "graphql" },
    groovy = { "groovyls" },
    html = { "html" },
    haskel = { "hls" },
    json = { "jsonls" },
    json5 = { "jsonls" },
    java = { "jdtls" },
    javascript = { "tsserver" },
    kotlin = { "kotlin_language_server" },
    latex = { "texlab" },
    ocaml = { "ocamells" },
    php = { "phpactor" },
    powershell = { "powershell_es" },
    python = { "pyright" },
    ruby = { "solargraph" },
    rust = { "rust_analyzer" },
    svelte = { "svelte" },
    typescript = { "tsserver" },
    vim = { "vimls" },
    vue = { "vuels" },
    xml = { "lemminx" },
    yaml = { "yamlls" },
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

local is_plugin_disabled = require("doom.utils").is_plugin_disabled
lsp.packages = {
  ["nvim-lspconfig"] = {
    "neovim/nvim-lspconfig",
    commit = "e7df7ecae0b0d2f997ea65e951ddbe98ca3e154b",
    opt = true,
    cmd = {
      "LspStart",
      "LspRestart",
      "LspStop",
    },
    module = "lspconfig",
  },
  ["nvim-cmp"] = {
    "hrsh7th/nvim-cmp",
    commit = "d93104244c3834fbd8f3dd01da9729920e0b5fe7",
    after = is_plugin_disabled("snippets") or "LuaSnip",
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
    commit = "c5230cb439df9547294678d0f1c1465ad7989e5f",
    after = "nvim-cmp",
  },
  ["cmp-buffer"] = {
    "hrsh7th/cmp-buffer",
    commit = "f83773e2f433a923997c5faad7ea689ec24d1785",
    after = "nvim-cmp",
  },
  ["cmp_luasnip"] = {
    "saadparwaiz1/cmp_luasnip",
    commit = "d6f837f4e8fe48eeae288e638691b91b97d1737f",
    after = "nvim-cmp",
    disabled = is_plugin_disabled("snippets"),
  },
  ["lsp_signature.nvim"] = {
    "ray-x/lsp_signature.nvim",
    commit = "1178ad69ce5c2a0ca19f4a80a4048a9e4f748e5f",
    after = "nvim-lspconfig",
    opt = true,
  },
}


lsp.configure_functions = {}
lsp.configure_functions["nvim-lspconfig"] = function()
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
    border = doom.border_style,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = doom.border_style,
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
lsp.configure_functions["nvim-cmp"] = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local replace_termcodes = require("doom.utils").replace_termcodes

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
        item.kind = string.format("%s %s", doom.modules.lsp.settings.completion.kinds[item.kind], item.kind)
        item.menu = source_map[entry.source.name]
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
    mapping = type(doom.modules.lsp.settings.completion.mapping) == "function" and doom.modules.lsp.settings.completion.mapping(cmp)
      or doom.modules.lsp.settings.completion.mapping,
    enabled = function()
      return _doom.cmp_enable and vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    end,
  }))
end
lsp.configure_functions["lsp_signature.nvim"] = function()
  -- Signature help
  require("lsp_signature").setup(vim.tbl_deep_extend("force", doom.modules.lsp.settings.signature, {
    handler_opts = {
      border = doom.border_style,
    },
  }))
end

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
          { "c", function() require("doom.core.functions").toggle_completion() end, name = "Toggle completion" },
        },
      },
    },
  }
}

return lsp
