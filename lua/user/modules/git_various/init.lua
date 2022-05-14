local git = {}
git.settings = {}
git.packages = {
  ["git-blame.nvim"] = { 'f-person/git-blame.nvim' },
  -- ["gitlinker.nvim"] = { 'ruifm/gitlinker.nvim' },
  -- ["github-notifications.nvim"] = { 'rlch/github-notifications.nvim' },
  -- ["igs.nvim"] = { 'rmagatti/igs.nvim' },
  -- ["gitstat.nvim"] = { 'kyoh86/gitstat.nvim' },
  -- ["githublink.nvim"] = { 'knsh14/githublink.nvim' },
  -- ["gitignore-grabber.nvim"] = { 'antonk52/gitignore-grabber.nvim' },
  -- ["cmp-git"] = { 'petertriho/cmp-git' }, -- wip / unstable..
  -- https://github.com/ThePrimeagen/git-worktree.nvim
    -- https://github.com/nickgerace/gfold
}

-- git.binds = {
--   { "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>', name = "select hunk", mode = "o" },
--   { "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>', name = "select hunk", mode = "x" },
--   {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "g",
--         name = "+git",
--         {
--           {
--             "z",
--             name = "+gitsigns",
--             {
--               { "S", '<cmd>lua require"gitsigns".stage_hunk()<CR>', name = "stage hunk" },
--               { "u", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', name = "undo hunk" },
--               { "r", '<cmd>lua require"gitsigns".reset_hunk()<CR>', name = "reset hunk" },
--               { "R", '<cmd>lua require"gitsigns".reset_buffer()<CR>', name = "reset buffer" },
--               { "h", '<cmd>lua require"gitsigns".preview_hunk()<CR>', name = "preview hunk" },
--               { "b", '<cmd>lua require"gitsigns".blame_line()<CR>', name = "blame line" },
--             },
--           },
--         },
--       },
--     },
--   },
-- }


return git
