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
}
local specs = {
}
local groups = {
  TelescopeNormal = { fg = 'fg0', bg = 'bg0' },
  TelescopePromptTitle = { fg = "bg0", bg = "pallet.green" },
  TelescopePromptBorder = { fg = "bg1", bg = "bg1" },
  TelescopePromptNormal = { fg = "fg1", bg = "bg1" },
  TelescopePromptPrefix = { fg = "fg1", bg = "bg1" },

  TelescopeResultsTitle = { fg = "bg3", bg = "pallet.green" },
  TelescopeResultsBorder = { fg = 'bg3', bg = 'bg3' },
  TelescopeResultsNormal = { fg = 'fg1', bg = 'bg3' },

  TelescopePreviewTitle = { fg = "bg1", bg = "pallet.green" },
  TelescopePreviewNormal = { bg = 'bg1' },
  TelescopePreviewBorder = { fg = "bg1", bg = "bg1" },
  TelescopeMatching = { fg = "error" },
  CursorLine = { bg = "bg2" },
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
