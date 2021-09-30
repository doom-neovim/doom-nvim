---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------
-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()
-- Lua modules loader, when loading our modules with this
-- we avoid breaking all the configuration if something fails
local load_modules = require("doom.utils").load_modules

-- Disable some unused built-in Neovim plugins
vim.g.loaded_gzip = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false

local doom_root, sep = require("doom.core.system").doom_root, require("doom.core.system").sep
local compiled_plugins_path = ("%s%splugin%spacker_compiled.lua"):format(doom_root, sep, sep)
local compiled_plugins_exists = require("doom.utils").file_exists(compiled_plugins_path)
if not compiled_plugins_exists then
  -- bootstrap start only -- no deferred loading
  -- ensure packer availability only
  load_modules("doom", {"modules"})
  -- followings are blocked until packages are loaded
  vim.cmd("PackerInstall")
  vim.cmd("PackerCompile")
  -- packages in start path may cause noise.  Ignore and type ":"
  -- Once successful, use ":q!" to get out and restart nvim.
else
---- Doom Configurations ------------------------
-------------------------------------------------
-- Load Doom core and UI related stuff (colorscheme, background)
load_modules("doom", { "core" })

vim.defer_fn(function()
  -- Load Doom extra stuff and plugins (modules, extras)
  load_modules("doom", { "modules", "extras" })

  -- If the current buffer name is empty then trigger Dashboard.
  -- NOTE: this is done to avoid some weird issues with Dashboard and
  --       number / signcolumn when Dashboard gets triggered automatically
  if
    (vim.api.nvim_buf_get_name(0):len() == 0)
    and (packer_plugins and packer_plugins["dashboard-nvim"])
  then
    vim.cmd("Dashboard")
  end

  vim.cmd([[
    PackerLoad nvim-treesitter
    " This BufEnter call should fix some issues with concealing in neorg
    doautocmd BufEnter
  ]])

  if not require("doom.core.functions").is_plugin_disabled("which-key") then
    vim.cmd([[
      PackerLoad which-key.nvim
    ]])
  end
end, 0)
end
