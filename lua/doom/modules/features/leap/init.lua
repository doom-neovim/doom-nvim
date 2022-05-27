local motion = {}

-- todo: abort timeout
-- todo: leap enter/leave disable neorg rendered

motion.settings = {}

motion.packages = {
  ["leap.nvim"] = {"ggandor/leap.nvim" },
  -- ["lightspeed.nvim"] = { "ggandor/lightspeed.nvim" },
  -- https://github.com/mfussenegger/nvim-treehopper
}

motion.configs = {}

motion.configs["leap.nvim"] = function()
  require('leap').setup {
    case_insensitive = true,
    -- Leaving the appropriate list empty effectively disables "smart" mode,
    -- and forces auto-jump to be on or off.
    safe_labels = {},
    labels = {},
    -- These keys are captured directly by the plugin at runtime.
    special_keys = {
      repeat_search = '<enter>',
      next_match    = '<enter>',
      prev_match    = '<tab>',
      next_group    = '<space>',
      prev_group    = '<tab>',
      eol           = '<space>',
    }
  }

  -- --- Searching in all windows (including the current one) on the tab page:
  -- local function leap_all_windows()
  --   require'leap'.leap {
  --     ['target-windows'] = vim.tbl_filter(
  --       function (win) return vim.api.nvim_win_get_config(win).focusable end,
  --       vim.api.nvim_tabpage_list_wins(0)
  --     )
  --   }
  -- end

  -- -- Bidirectional search in the current window is just a specific case of the
  -- -- multi-window mode - set `target-windows` to a table containing the current
  -- -- window as the only element:
  -- local function leap_bidirectional()
  --   require'leap'.leap { ['target-windows'] = { vim.api.nvim_get_current_win() } }
  -- end

  -- -- Map them to your preferred key, like:
  -- vim.keymap.set('n', 's', leap_all_windows, { silent = true })
  -- }

end

-- motion.configs["lightspeed.nvim"] = function()
--   require("lightspeed").setup({
--     ignore_case = false,
--     exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
--     --- s/x ---
--     jump_to_unique_chars = { safety_timeout = 400 },
--     match_only_the_start_of_same_char_seqs = true,
--     force_beacons_into_match_width = false,
--     -- Display characters in a custom way in the highlighted matches.
--     substitute_chars = { ["\r"] = "¬" },
--     -- Leaving the appropriate list empty effectively disables "smart" mode,
--     -- and forces auto-jump to be on or off.
--     -- safe_labels = { . . . },
--     -- labels = { . . . },
--     -- These keys are captured directly by the plugin at runtime.
--     special_keys = {
--       next_match_group = "<space>",
--       prev_match_group = "<tab>",
--     },
--     --- f/t ---
--     limit_ft_matches = 4,
--     repeat_ft_with_target_char = false,
--   })
-- end

-- motion.binds = {}

-- https://github.com/ggandor/lightspeed.nvim/discussions/83
-- `<Plug>Lightspeed_s`  2-character  forward   /-like
-- `<Plug>Lightspeed_S`  2-character  backward  ?-like
-- `<Plug>Lightspeed_x`  2-character  forward   X-mode
-- `<Plug>Lightspeed_X`  2-character  backward  X-mode

-- `<Plug>Lightspeed_f`  1-character  forward   f-like
-- `<Plug>Lightspeed_F`  1-character  backward  F-like
-- `<Plug>Lightspeed_t`  1-character  forward   t-like
-- `<Plug>Lightspeed_T`  1-character  backward  T-like

return motion
