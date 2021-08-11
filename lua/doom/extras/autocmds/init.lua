---[[---------------------------------------]]---
--        autocmds - Doom Nvim Autocmds        --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local utils = require("doom.utils")
local log = require("doom.extras.logging")
local config = require("doom.core.config").load_config()

log.debug("Loading Doom autocmds module ...")

local autocmds = {
  doom_core = {
    -- Compile new plugins changes at save
    {
      "BufWritePost",
      "*/doom-*.lua,doomrc.lua,plugins.lua",
      "PackerCompile profile=true",
    },
    -- Reload user-defined settings when 'doom_config.lua' file was modified
    {
      "BufWritePost",
      "doom_config.lua",
      "lua require('doom.core.functions').reload_custom_settings()",
    },
    -- Automatically change colorscheme and background on exit
    {
      "VimLeavePre",
      "*",
      "lua require('doom.core.functions').change_colors_and_bg()",
    },
  },
  doom_extras = {
    -- Set up vim_buffer_previewer in telescope.nvim
    { "User", "TelescopePreviewerLoaded", "setlocal wrap" },
  },
}

-- Set relative numbers
if config.doom.relative_num then
  table.insert(autocmds["doom_core"], {
    "BufEnter,WinEnter",
    "*",
    "if &nu | set rnu | endif",
  })
else
  table.insert(autocmds["doom_core"], {
    "BufEnter,WinEnter",
    "*",
    "if &nu | set nornu | endif",
  })
end

-- Install plugins on launch
if config.doom.auto_install_plugins then
  vim.defer_fn(function()
    -- Check if there is only packer installed so we can decide if we should
    -- use PackerInstall or PackerSync, useful for generating the
    -- `plugin/packer_compiled.lua` on first doom launch
    if
      vim.tbl_count(vim.fn.globpath(vim.fn.stdpath("data") .. "/site/pack/packer/opt", "*", 0, 1))
      == 1
    then
      vim.cmd("PackerSync")
    else
      -- Clean disabled plugins
      vim.cmd("PackerClean")
      -- Install the plugins
      vim.cmd("PackerInstall")
    end
  end, 200)
end

-- Set autosave
if config.doom.autosave then
  table.insert(autocmds["doom_core"], {
    "TextChanged,InsertLeave",
    "<buffer>",
    "silent! write",
  })
end

-- Enable auto comment
if not config.doom.auto_comment then
  vim.opt.formatoptions:remove({ "c", "r", "o" })
end

-- Enable highlight on yank
if config.doom.highlight_yank then
  table.insert(autocmds["doom_core"], {
    {
      "TextYankPost",
      "*",
      "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
    },
  })
end

-- Format on save
-- NOTE: Requires formatter to be enabled!
if config.doom.fmt_on_save then
  table.insert(autocmds["doom_core"], {
    "BufWritePre",
    "*",
    "FormatWrite",
  })
end

-- Preserve last editing position
if config.doom.preserve_edit_pos then
  table.insert(autocmds["doom_core"], {
    "BufReadPost",
    "*",
    [[
      if line("'\"") > 1 && line("'\"") <= line("$") |
        exe "normal! g'\"" |
      endif
    ]],
  })
end

-- Create augroups
utils.create_augroups(autocmds)
