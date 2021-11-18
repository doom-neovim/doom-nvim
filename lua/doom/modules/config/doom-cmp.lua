return function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local kind_icons = {
    Text = "   ",
    Method = "  ",
    Function = "  ",
    Constructor = "  ",
    Field = " ﴲ ",
    Variable = "  ",
    Class = "  ",
    Interface = " ﰮ ",
    Module = "  ",
    Property = " ﰠ ",
    Unit = "  ",
    Value = "  ",
    Enum = " 練",
    Keyword = "  ",
    Snippet = "  ",
    Color = "  ",
    File = "  ",
    Reference = "  ",
    Folder = "  ",
    EnumMember = "  ",
    Constant = " ﲀ ",
    Struct = " ﳤ ",
    Event = "  ",
    Operator = "  ",
    TypeParameter = "  ",
  }
  --- Given an LSP item kind, returns a nerdfont icon
  --- @param kind_type string LSP item kind
  --- @return string Nerdfont Icon
  local function get_kind_icon(kind_type)
    return kind_icons[kind_type]
  end

  --- Wraps nvim_replace_termcodes
  --- @param str string
  --- @return string
  local function replace_termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  --- Helper function to check what <Tab> behaviour to use
  --- @return boolean
  local function check_backspace()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,preview,noinsert",
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    formatting = {
      format = function(entry, item)
        item.kind = string.format("%s %s", get_kind_icon(item.kind), item.kind)
        item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snp]",
          buffer = "[Buf]",
          nvim_lua = "[Lua]",
          path = "[Path]",
        })[entry.source.name]
        item.dup = ({
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
        })[entry.source.name] or 0
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
  })
end
