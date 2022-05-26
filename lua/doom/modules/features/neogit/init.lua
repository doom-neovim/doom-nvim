local neogit = {}

-- neogit.settings = {
--   -- override/add mappings
--   mappings = {
--     -- modify status buffer mappings
--     status = {
--       -- Removes the default mapping of "s"
--       ["s"] = "a",
--       ["S"] = "A",
--     },
--   },
-- }

neogit.settings = {}

neogit.packages = {
  ["neogit"] = {
    "TimUntersberger/neogit",
    commit = "cec7fd91ce9d7a5a5027e85eea961adfa4776dd4",
    cmd = "Neogit",
    opt = true,
  },
}

-- n.packages = {
--   m.neogit.packages["neogit"][1] = gh .. "TimUntersberger/neogit"
-- }

-- return function()
--   local neogit = require("neogit")
--
--   neogit.setup {
--     disable_signs = false,
--     disable_hint = false,
--     disable_context_highlighting = false,
--     disable_commit_confirmation = false,
--     auto_refresh = true,
--     disable_builtin_notifications = false,
--     commit_popup = {
--       kind = "split",
--     },
--     -- Change the default way of opening neogit
--     kind = "tab",
--     -- customize displayed signs
--     signs = {
--       -- { CLOSED, OPENED }
--       section = { ">", "v" },
--       item = { ">", "v" },
--       hunk = { "", "" },
--     },
--     integrations = {
--       -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
--       -- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
--       --
--       -- Requires you to have `sindrets/diffview.nvim` installed.
--       -- use {
--       --   'TimUntersberger/neogit',
--       --   requires = {
--       --     'nvim-lua/plenary.nvim',
--       --     'sindrets/diffview.nvim'
--       --   }
--       -- }
--       --
--       diffview = true
--     },
--     -- Setting any section to `false` will make the section not render at all
--     sections = {
--       untracked = {
--         folded = false
--       },
--       unstaged = {
--         folded = false
--       },
--       staged = {
--         folded = false
--       },
--       stashes = {
--         folded = true
--       },
--       unpulled = {
--         folded = true
--       },
--       unmerged = {
--         folded = false
--       },
--       recent = {
--         folded = true
--       },
--     },
--     -- override/add mappings
--     mappings = {
--       -- modify status buffer mappings
--       status = {
--         -- Adds a mapping with "B" as key that does the "BranchPopup" command
--         ["B"] = "BranchPopup",
--         -- Removes the default mapping of "s"
--         ["s"] = "a",
--         ["S"] = "A",
--       }
--     }
--   }
-- end

-- -- NEOGIT
-- -- :Neogit " uses tab
-- -- :Neogit kind=<kind> " override kind
-- -- :Neogit cwd=<cwd> " override cwd
-- -- :Neogit commit" open commit popup
neogit.configs = {}
neogit.configs["neogit"] = function()
  require("neogit").setup(doom.features.neogit.settings)
end

-- neogit.binds = {
--   "<leader>",
--   name = "+prefix",
--   {
--     {
--       "o",
--       name = "+open/close",
--       {
--         { "g", "<cmd>Neogit<CR>", name = "Neogit" },
--       },
--     },
--     {
--       "g",
--       name = "+git",
--       {
--         { "g", "<cmd>Neogit<CR>", name = "Open neogit" },
--       },
--     },
--   },
-- }

neogit.binds = {
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "o",
        name = "+open/close",
        {
          { "g", "<cmd>Neogit<CR>", name = "Neogit" },
        },
      },
      {
        "g",
        name = "+git",
        {
          { "g", "<cmd>Neogit<CR>", name = "Open neogit" },
          {
            "n",
            name = "+neogit",
            {
              -- -- { 'n', '<leader>lnh', '<cmd>lua require("neogit").open({ kind = "vsplit", cwd = "~" })<CR>', opts.s},
              { 'o', '<cmd>Neogit<CR>', name = "open"},
              { 'c', '<cmd>Neogit commit<CR>', name = "commit"},
              -- { 'n', '<leader>lnl', '<cmd>Neogit pull<CR>', opts.s}, -- TODO: pull
              -- { 'n', '<leader>lnp', '<cmd>Neogit push<CR>', opts.s}, -- TODO: push
              -- { 'n', '<leader>lnb', '<cmd>Neogit branch<CR>', opts.s}, -- TODO: push
              -- { 'n', '<leader>lnv', '<cmd>Neogit log<CR>', opts.s}, -- TODO: push
              -- { 'n', '<leader>lns', '<cmd>Neogit stash<CR>', opts.s}, -- TODO: push
            },
          },
        },
      },
    },
  },
}

return neogit
