local motion = {}

motion.settings = {}

-- https://github.com/mfussenegger/nvim-treehopper

motion.packages = {
  -- git@github.com:ggandor/leap.nvim.git -- successor to lightspeed. very cool motions.
  ["lightspeed.nvim"] = { "ggandor/lightspeed.nvim" },
  -- { 'justinmk/vim-sneak' },
  -- { 'easymotion/vim-easymotion' },
}

-- need to add timeout to lightspeed!! goback to narmal
motion.configs = {}

motion.configs["lightspeed.nvim"] = function()
  require("lightspeed").setup({
    ignore_case = false,
    exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },

    --- s/x ---
    jump_to_unique_chars = { safety_timeout = 400 },
    match_only_the_start_of_same_char_seqs = true,
    force_beacons_into_match_width = false,
    -- Display characters in a custom way in the highlighted matches.
    substitute_chars = { ["\r"] = "¬" },
    -- Leaving the appropriate list empty effectively disables "smart" mode,
    -- and forces auto-jump to be on or off.
    -- safe_labels = { . . . },
    -- labels = { . . . },
    -- These keys are captured directly by the plugin at runtime.
    special_keys = {
      next_match_group = "<space>",
      prev_match_group = "<tab>",
    },

    --- f/t ---
    limit_ft_matches = 4,
    repeat_ft_with_target_char = false,
  })
end

------------------------------
---       lightspeed       ---
------------------------------
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
