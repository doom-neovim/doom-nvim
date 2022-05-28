local tsctx = {}

tsctx.packages = {
  ["nvim-treesitter-context"] = {
    "nvim-treesitter/nvim-treesitter-context",
    requires = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    opt = true,
  }
}

tsctx.configs = {}

tsctx.configs["nvim-treesitter-context"] = function()
  require'treesitter-context'.setup{
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          default = {-- For all filetypes Note that setting an entry here replaces all other patterns for this entry. By setting the 'default' entry below, you can control which nodes you want to appear in the context window.
              'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case',
          },
          -- Example for a specific filetype.
          -- If a pattern is missing, *open a PR* so everyone can benefit.
          --   rust = {
          --       'impl_item',
          --   },
      },
      exact_patterns = {
          -- Example for a specific filetype with Lua patterns Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will exactly match "impl_item" only)
          -- rust = true,
      },
      -- [!] The options below are exposed but shouldn't require your attention, you can safely ignore them.
      zindex = 20, -- The Z-index of the context window
  }
end

tsctx.binds = {
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

return tsctx
