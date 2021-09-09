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
  local function get_kind(kind_type)
    return kind_icons[kind_type]
  end

  local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  local function check_backspace()
    local col = vim.fn.col "." - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
      return true
    else
      return false
    end
  end

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,preview,noinsert",
    },
    formatting = {
      format = function(entry, item)
        item.kind = string.format("%s %s", get_kind(item.kind), item.kind)
        item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snp]",
          buffer = "[Buf]",
          nvim_lua = "[Lua]",
          path = "[Path]",
        })[entry.source.name]

        return item
      end,
    },
    mappings = {
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<C-e>"] = cmp.mapping.close(),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(t("<C-n>"), "n")
        elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
        elseif check_backspace() then
          vim.fn.feedkeys(t("<Tab>"), "n")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(t("<C-p>"), "n")
        elseif luasnip.jumpable(-1) then
          vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
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
