local binds = {
  { "<leader>c", name = '+code', {
    { 'g', ':lua require("neogen").generate()<CR>', name = 'Generate annotations'}
  } },
}

return binds
