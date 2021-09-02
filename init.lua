---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------
-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()

-- Disable these for very fast startup time
vim.cmd([[
  syntax off
  filetype off
  filetype plugin indent off
]])

-- Temporarily disable shada file to improve performance
vim.opt.shadafile = "NONE"
-- Disable some unused built-in Neovim plugins
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false

---- Doom Configurations ------------------------
-------------------------------------------------
vim.defer_fn(function()
  local load_modules = require("doom.utils").load_modules

  -- Load Doom stuff (core, modules, extras)
  load_modules("doom", { "core", "modules", "extras.autocmds" })

  -- If the dashboard plugin is already installed and the packer_compiled.lua
  -- file exists so we can make sure that the dashboard have been loaded.
  local doom_root, sep = require("doom.core.system").doom_root, require("doom.core.system").sep
  local compiled_plugins_path = string.format(
    "%s%splugin%spacker_compiled.lua",
    doom_root,
    sep,
    sep
  )
  if require("doom.utils").file_exists(compiled_plugins_path) then
    -- If the current buffer name is empty then trigger Dashboard.
    -- NOTE: this is done to avoid some weird issues with Dashboard and
    --       number / signcolumn when Dashboard gets triggered automatically
    if (vim.api.nvim_buf_get_name(0):len() == 0) and packer_plugins["dashboard-nvim"] then
      vim.cmd("Dashboard")
    end
  end

  vim.opt.shadafile = ""
  vim.cmd([[
    rshada!
    doautocmd BufRead
    syntax on
    filetype on
    filetype plugin indent on
    PackerLoad nvim-treesitter
  ]])

  -- Load keybindings module at the end because the keybindings module cost is high
  vim.defer_fn(function()
    load_modules("doom.extras", { "keybindings" })
    vim.cmd([[
      PackerLoad which-key.nvim
      silent! bufdo e
    ]])
  end, 20)
end, 0)
