local binds = {
  {
    "<Tab>",
    [[luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"]],
    name = "Expand snippet",
  },
  {
    mode = "i",
    {
      {
        "<Tab>",
        function()
          require("luasnip").jump(1)
        end,
        name = "Next snippet section",
      },
    },
  },
  {
    mode = "s",
    {
      {
        "<S-Tab>",
        function()
          require("luasnip").jump(-1)
        end,
        name = "Previous snippet section",
      },
    },
  },
  {
    mode = "i",
    {
      {
        "<C-E>",
        [[luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"]],
        name = "Next snippet field",
      },
    },
  },
  {
    mode = "s",
    {
      {
        "<C-E>",
        [[luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"]],
        name = "Next snippet field",
      },
    },
  },
}

return binds
