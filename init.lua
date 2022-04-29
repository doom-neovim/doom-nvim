-- Add ~/.local/share to runtimepath early, such that
-- neovim autoloads plugin/packer_compiled.lua along with vimscript,
-- before we start using the plugins it lazy-loads.
vim.opt.runtimepath:append(vim.fn.stdpath("data"))

-- Load the doom-nvim framework
require("doom.core")



