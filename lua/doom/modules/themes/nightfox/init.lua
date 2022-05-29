local themes = {}

themes.settings = {}

themes.packages = {
  ["nightfox.nvim"] = { "EdenEast/nightfox.nvim" },
}

-- themes.configs = {}

-- -- Default options
-- require('nightfox').setup({
--   options = {
--     -- Compiled file's destination location
--     compile_path = vim.fn.stdpath("cache") .. "/nightfox",
--     compile_file_suffix = "_compiled", -- Compiled file suffix
--     transparent = false,    -- Disable setting background
--     terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
--     dim_inactive = false,   -- Non focused panes set to alternative background
--     styles = {              -- Style to be applied to different syntax groups
--       comments = "NONE",    -- Value is any valid attr-list value `:help attr-list`
--       conditionals = "NONE",
--       constants = "NONE",
--       functions = "NONE",
--       keywords = "NONE",
--       numbers = "NONE",
--       operators = "NONE",
--       strings = "NONE",
--       types = "NONE",
--       variables = "NONE",
--     },
--     inverse = {             -- Inverse highlight for different types
--       match_paren = false,
--       visual = false,
--       search = false,
--     },
--     modules = {             -- List of various plugins and additional options
--       -- ...
--     },
--   }
-- })

-- -- setup must be called before loading
-- vim.cmd("colorscheme nightfox")
-- themes.configs["nightfox.nvim"] = function()
--   local options = {
--     dim_inactive = true,
--   }
--   local palette = {
--     dawnfox = {
--       bg2 = "#F9EFEC",
--       bg3 = "#ECE3DE",
--       sel1 = "#EEF1F1",
--       sel2 = "#D8DDDD",
--     },
--   }
--   local specs = {}
--   local groups = {
--     TelescopeNormal = { fg = "fg0", bg = "bg0" },
--     TelescopePromptTitle = { fg = "pallet.green", bg = "bg1" },
--     TelescopePromptBorder = { fg = "bg1", bg = "bg1" },
--     TelescopePromptNormal = { fg = "fg1", bg = "bg1" },
--     TelescopePromptPrefix = { fg = "fg1", bg = "bg1" },
--     TelescopeResultsTitle = { fg = "pallet.green", bg = "bg2" },
--     TelescopeResultsBorder = { fg = "bg2", bg = "bg2" },
--     TelescopeResultsNormal = { fg = "fg1", bg = "bg2" },
--     TelescopePreviewTitle = { fg = "pallet.green", bg = "bg1" },
--     TelescopePreviewNormal = { bg = "bg1" },
--     TelescopePreviewBorder = { fg = "bg1", bg = "bg1" },
--     TelescopeMatching = { fg = "error" },
--     CursorLine = { bg = "sel1", link = "" },
--   }
--   require("nightfox").setup({
--     options = options,
--     palette = palette,
--     specs = specs,
--     groups = groups,
--   })
-- end

return themes
