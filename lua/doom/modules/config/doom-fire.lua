return function()

  -- TODO: this option should make firenvim NOT trigger on enter textarea
  -- so that user can trigger nvim with keybinding instead.
  -- however, something is not working here so...
  -- NOTE: see this issue for help https://github.com/glacambre/firenvim/issues/991

  -- required global config object
  -- vim.cmd([[
  --   let g:firenvim_config = {
  --     \ 'globalSettings': {
  --         \ 'alt': 'all',
  --     \  },
  --     \ 'localSettings': {
  --         \ '.*': {
  --             \ 'cmdline': 'neovim',
  --             \ 'content': 'text',
  --             \ 'priority': 0,
  --             \ 'selector': 'textarea',
  --             \ 'takeover': 'always',
  --         \ },
  --     \ }
  --   \ }
  -- ]])

  -- -- disable nvim from triggering on entering textarea
  -- vim.cmd([[
  --   let fc = g:firenvim_config['localSettings']
  --   let fc['.*'] = { 'takeover': 'never' }
  -- ]])
end
