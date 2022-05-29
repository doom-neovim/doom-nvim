local themes = {}

themes.settings = {}

themes.packages = {
  ["nvim-transparent"] = { "xiyaowong/nvim-transparent" },
}

themes.configs = {}

themes.configs["nvim-transparent"] = function()
  require("transparent").setup({
    enable = false, -- boolean: enable transparent
    extra_groups = { -- table/string: additional groups that should be clear
      -- In particular, when you set it to 'all', that means all avaliable groups
      -- example of akinsho/nvim-bufferline.lua
      "BufferLineTabClose",
      "BufferlineBufferSelected",
      "BufferLineFill",
      "BufferLineBackground",
      "BufferLineSeparator",
      "BufferLineIndicatorSelected",
    },
    exclude = {}, -- table: groups you don't want to clear
  })
end

return themes
