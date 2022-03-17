-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).
--

-- Editor config
doom.indent = 2
doom.escape_sequences = {}
doom.modules.telescope.settings.defaults.layout_config.prompt_position = "top"
-- vim.lsp.set_log_level('trace')
vim.diagnostic.config({
  float = {
    source = 'always',
  },
})

doom.modules.tabline.settings.options.numbers = nil; -- Hide buffer numbers
doom.modules.tabline.settings.options.diagnostics_indicator = function (_, _, diagnostics_dict, _)
  local s = ""
  for e, _ in pairs(diagnostics_dict) do
    local sym = e == "error" and " " or (e == "warning" and " " or " ")
    s = s .. sym
  end
  return s
end

-- Colourscheme
table.insert(doom.packages, {
  'sainnhe/sonokai'
})
table.insert(doom.packages, {
  'EdenEast/nightfox.nvim',
})
local options = {
  dim_inactive = true,
}
local pallets = {
  dawnfox = {
    bg2 = '#F9EFEC',
    bg3 = '#ECE3DE',
    sel1 = '#EEF1F1',
    sel2 = '#D8DDDD',
  }
}
local specs = {
}
local groups = {
  TelescopeNormal = { fg = 'fg0', bg = 'bg0' },
  TelescopePromptTitle = { fg = "pallet.green", bg = "bg1" },
  TelescopePromptBorder = { fg = "bg1", bg = "bg1" },
  TelescopePromptNormal = { fg = "fg1", bg = "bg1" },
  TelescopePromptPrefix = { fg = "fg1", bg = "bg1" },

  TelescopeResultsTitle = { fg = "pallet.green", bg = "bg2" },
  TelescopeResultsBorder = { fg = 'bg2', bg = 'bg2' },
  TelescopeResultsNormal = { fg = 'fg1', bg = 'bg2' },

  TelescopePreviewTitle = { fg = "pallet.green", bg = "bg1" },
  TelescopePreviewNormal = { bg = 'bg1' },
  TelescopePreviewBorder = { fg = "bg1", bg = "bg1" },
  TelescopeMatching = { fg = "error" },
  CursorLine = { bg = "sel1", link = "" },
}
require('nightfox').setup({
  options = options,
  pallets = pallets,
  specs = specs,
  groups = groups,
})
doom.colorscheme = 'dawnfox'

-- Extra packages
table.insert(doom.packages, {
  'rafcamlet/nvim-luapad'
})
table.insert(doom.packages, {
  'nvim-treesitter/playground'
})
table.insert(doom.packages, {
  'tpope/vim-surround'
})

table.insert(doom.packages, {
  'dstein64/vim-startuptime'
})
vim.opt.guifont = { 'Hack Nerd Font', 'h12' }

-- vim: sw=2 sts=2 ts=2 expandtab
