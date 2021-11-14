---[[---------------------------------------]]---
--        autocmds - Doom Nvim Autocmds        --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local utils = require("doom.utils")
local log = require("doom.extras.logging")
local config = require("doom.core.config").config
local is_plugin_disabled = require("doom.utils").is_plugin_disabled

log.debug("Loading Doom autocmds module ...")

local autocmds = {
  doom_core = {
    -- Compile new plugins configurations changes at save
    {
      "BufWritePost",
      "*/config/doom-*.lua",
      "PackerCompile profile=true",
    },
    -- Compile modules and custom plugins changes at exit, in that way we avoid
    -- weird errors of Packer complaining about uninstalled plugins on startup
    {
      "VimLeavePre",
      "doom_modules.lua,doom_userplugins.lua",
      "PackerCompile profile=true",
    },
    -- Live-reload plugins and automatically install or clean them at save
    {
      "BufWritePost",
      "doom_modules.lua,doom_userplugins.lua",
      "lua require('doom.modules.built-in.reloader').reload_plugins_definitions()",
    },
    -- Live-reload user-defined settings when 'doom_config.lua' file was modified
    {
      "BufWritePost",
      "doom_config.lua",
      "lua require('doom.core.functions').reload_custom_settings()",
    },
    -- Live-reload plugins configuration files
    {
      "BufWritePost",
      "*/config/doom-*.lua",
      "lua require('doom.modules.built-in.reloader').reload_lua_module(vim.fn.expand('%:p'))",
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

-- Set numbering
if not config.doom.disable_numbering then
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
      -- Defer the installation of new plugins to avoid a weird bug where packer
      -- tries to clean the plugins that are being installed right now
      vim.defer_fn(function()
        -- Install the plugins
        vim.cmd("PackerInstall")
      end, 200)
    end
  end, 400)
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

-- Linting
if not is_plugin_disabled("linter") and packer_plugins and packer_plugins["nvim-lint"] then
  table.insert(autocmds["doom_extras"], {
    "BufWinEnter,BufWritePost",
    "<buffer>",
    "lua require('lint').try_lint()",
  })
end

-- Quickly exit Neovim on dashboard
if not is_plugin_disabled("dashboard") then
  table.insert(autocmds["doom_extras"], {
    "FileType",
    "dashboard",
    "nnoremap <silent> <buffer> q :q<CR>",
  })
end

-- Show line diagnostics on hover
if not config.doom.enable_lsp_virtual_text then
  table.insert(autocmds["doom_extras"], {
    "CursorHold,CursorHoldI",
    "<buffer>",
    'lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false, border = "single" })',
  })
end

-- Eye candy netrw (add icons)
if config.doom.use_netrw then
  table.insert(autocmds["doom_extras"], {
    "FileType",
    "netrw",
    "lua require('doom.core.settings.netrw').set_maps()",
  })
  table.insert(autocmds["doom_extras"], {
    "FileType",
    "netrw",
    "lua require('doom.core.settings.netrw').draw_icons()",
  })
  table.insert(autocmds["doom_extras"], {
    "TextChanged",
    "*",
    "lua require('doom.core.settings.netrw').draw_icons()",
  })
end

-- Create augroups
utils.create_augroups(autocmds)
