return function()
  -- TODO: this option should make firenvim NOT trigger on enter textarea
  -- so that user can trigger nvim with keybinding instead.
  -- however, something is not working here so...
  -- NOTE: see this issue for help https://github.com/glacambre/firenvim/issues/991

  -- required global config object
  vim.g.firenvim_config = {
    globalSettings = {
      alt = "all",
    },
    localSettings = {
      [".*"] = {
        cmdline = "neovim",
        content = "text",
        priority = 0,
        selector = "textarea",
        takeover = "never",
      },
    },
  }

  -- disable nvim from triggering on entering textarea
  local fc = vim.g.firenvim_config.localSettings
  fc["https?://github.com/"] = {
    takeover = "always",
    priority = 1,
  }

  -- Change the filetype to enable proper syntax highlighting
  vim.cmd([[ autocmd BufEnter github.com_*.txt set filetype=markdown ]])
end
