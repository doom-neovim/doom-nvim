-- Check if user is running Doom in a supported Neovim version before trying to load anything
if vim.fn.has("nvim-0.6.0") ~= 1 then
  vim.notify(
    "You are using an unsupported Neovim version, doom-nvim requires at least Neovim 0.6.0 to work as expected.\nPlease consider upgrading Neovim before using doom-nvim",
    vim.log.levels.ERROR
  )
  return
end

-- Makes sure ~/.local/share/nvim exists, to prevent problems with logging
vim.fn.mkdir(vim.fn.stdpath("data"), "p")

-- Add ~/.local/share to runtimepath early, such that
-- neovim autoloads plugin/packer_compiled.lua along with vimscript,
-- before we start using the plugins it lazy-loads.
vim.opt.runtimepath:append(vim.fn.stdpath("data"))

-- Load the doom-nvim framework
require("doom.core")

vim.defer_fn(function()
  -- Check for updates
  if doom.check_updates and doom.core.updater then
    doom.core.updater.check_updates(true)
  end
end, 0)
