-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).
--

-- Editor config
doom.indent = 2
doom.escape_sequences = {}
-- vim.lsp.set_log_level('trace')
vim.diagnostic.config({
  float = {
    source = 'always',
  },
})

-- Colourscheme
table.insert(doom.packages, {
  'sainnhe/sonokai'
})
doom.colorscheme = 'sonokai'

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


-- vim: sw=2 sts=2 ts=2 expandtab
