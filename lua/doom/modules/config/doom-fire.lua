return function()

  -- TODO: this option should make firenvim NOT trigger on enter textarea
  -- so that user can trigger nvim with keybinding instead.
  -- however, something is not working here so...
  -- NOTE: see this issue for help https://github.com/glacambre/firenvim/issues/991
  -- vim.cmd([[ let fc['.*'] = { 'takeover': 'never' } ]])
end
