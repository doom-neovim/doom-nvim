local ts_args = {}

ts_args.packages = {
  ["hlargs.nvim"] = { "m-demare/hlargs.nvim", },
  ["iswap.nvim"] = {"mizlan/iswap.nvim"} -- re-arrange args easilly
  -- https://github.com/rohit-px2/nvim-ts-highlightparams
}

ts_args.configs = {}
ts_args.configs["hlargs.nvim"] = function()
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


-- #usage
-- Run the command :ISwap when your cursor is in a location that is suitable for swapping around things. These include lists/arrays, function arguments, and parameters in function definitions. Then, hit two keys corresponding to the items you wish to be swapped. After both keys are hit, the text should immediately swap in the buffer. See the gif above for example usage.
-- Use :ISwapWith if you want to have the element your cursor is over automatically as one of the elements. This way, you only need one keypress to make a swap.

-- ts_args.configs["iswap.nvim"] = function()
-- end


ts_args.binds = {
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

return ts_args

