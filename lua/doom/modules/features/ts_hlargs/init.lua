local hlargs = {}

hlargs.packages = {
  ["hlargs.nvim"] = {
    "m-demare/hlargs.nvim",
    requires = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  -- https://github.com/rohit-px2/nvim-ts-highlightparams
}

hlargs.configs = {}
hlargs.configs["nvim-treesitter-context"] = function()
  require('hlargs').setup() -- detaults
  -- require('hlargs').setup {
  --   color = '#ef9062',
  --   highlight = {},
  --   excluded_filetypes = {},
  --   disable = function(lang, bufnr) -- If changed, `excluded_filetypes` will be ignored
  --     return vim.tbl_contains(opts.excluded_filetypes, lang)
  --   end,
  --   paint_arg_declarations = true,
  --   paint_arg_usages = true,
  --   hl_priority = 10000,
  --   excluded_argnames = {
  --     declarations = {},
  --     usages = {
  --       python = { 'self', 'cls' },
  --       lua = { 'self' }
  --     }
  --   },
  --   performance = {
  --     parse_delay = 1,
  --     slow_parse_delay = 50,
  --     max_iterations = 400,
  --     max_concurrent_partial_parses = 30,
  --     debounce = {
  --       partial_parse = 3,
  --       partial_insert_mode = 100,
  --       total_parse = 700,
  --       slow_parse = 5000
  --     }
  --   }
  -- }
end

hlargs.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "n",
      name = "+test",
      {
        {
          {
            "t",
            name = "+ts",
            -- TSContextEnable, TSContextDisable and TSContextToggle.
            { "c", [[ :TSContextToggle<cr> ]], name = "toggle context" },
          },
        },
      },
    },
  },
}

return hlargs

