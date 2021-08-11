---[[---------------------------------------]]---
--     doomrc.lua - Load Doom Nvim doomrc      --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local utils = require("doom.utils")
local system = require("doom.core.system")
local log = require("doom.extras.logging")

local M = {}

log.debug("Loading Doom doomrc module ...")

-- default_doomrc_values loads the default doomrc values
-- @return table
local function default_doomrc_values()
  return {
    ui = {
      "dashboard",      -- Start screen
      -- 'doom-themes', -- Additional doom emacs' colorschemes
      "statusline",     -- Statusline
      "tabline",        -- Tabline, shows your buffers list at top
      -- 'zen',         -- Distraction free environment
      "which-key",      -- Keybindings popup menu like Emacs' guide-key
      -- "show_registers", -- popup that shows register contents
      -- 'indentlines',    -- Show indent lines
    },
    doom = {
      -- 'neorg',    -- Life Organization Tool
      -- 'runner',   -- Open a REPL for the current language or run the current file
      -- 'compiler', -- Compile (and run) your code with just pressing three keys!
    },
    editor = {
      "auto-session", -- A small automated session manager for Neovim
      -- 'terminal',     -- Terminal for Neovim (NOTE: needed for runner and compiler)
      "explorer", -- Tree explorer
      -- "ranger", -- Ranger File Browser, requires ranger file browser
      "symbols", -- LSP symbols and tags
      -- 'minimap',      -- Code minimap, requires github.com/wfxr/code-minimap
      "gitsigns", -- Git signs
      "telescope", -- Highly extendable fuzzy finder over lists
      "formatter", -- File formatting
      "autopairs", -- Autopairs
      -- 'editorconfig', -- EditorConfig support for Neovim
      "kommentary", -- Comments plugin
      "lsp", -- Language Server Protocols
      "snippets", -- LSP snippets
    },
    langs = {
      -- To enable the language server for a language just add the +lsp flag
      -- at the end, e.g. 'rust +lsp'. This will install the rust TreeSitter
      -- parser and rust-analyzer
      --
      -- 'html',        -- HTML support
      -- 'css',         -- CSS support
      -- 'javascript',  -- JavaScript support
      -- 'typescript',  -- TypeScript support
      -- 'bash',        -- The terminal gods language
      -- 'python +lsp', -- Python support + lsp
      -- 'ruby',        -- Look ma, I love the gems!
      "lua", -- Support for our gods language
      -- 'elixir',      -- Build scalable and maintainable software
      -- 'haskell',     -- Because Functional programming is fun, isn't it?

      -- 'rust +lsp',   -- Let's get rusty!
      -- 'go',          -- Hello, gopher
      -- 'cpp',         -- C++ support
      -- 'java',        -- Java support

      -- 'config',      -- Configuration files (JSON, YAML, TOML)
      -- 'dockerfile',  -- Do you like containers, right?
    },
    utilities = {
      -- 'suda',            -- Write and read files without sudo permissions
      -- 'lazygit',         -- LazyGit integration for Neovim, requires LazyGit
      -- 'neogit',          -- Magit for Neovim
      "range-highlight", -- hightlights ranges you have entered in commandline
    },
    web = {
      -- 'restclient',   -- A fast Neovim http client
      -- "firenvim",          -- requires firenvim extension to be installed in webbrowser
      -- 'colorizer',       -- Fastets colorizer for Neovim
    }
  }
end

-- load_doomrc Loads the doomrc if it exists, otherwise it'll fallback to doom
-- default configs.
M.load_doomrc = function()
  local config, doomrc_path

  -- Path cases:
  --   1. /home/user/.config/doom-nvim/doomrc.lua
  --   2. /home/user/.config/nvim/doomrc.lua
  if utils.file_exists(string.format("%s%sdoomrc.lua", system.doom_configs_root, system.sep)) then
    doomrc_path = string.format("%s%sdoomrc.lua", system.doom_configs_root, system.sep)
  elseif utils.file_exists(string.format("%s%sdoomrc.lua", system.doom_root, system.sep)) then
    doomrc_path = string.format("%s%sdoomrc.lua", system.doom_root, system.sep)
  end

  if doomrc_path then
    local loaded_doomrc, err = pcall(function()
      log.debug("Loading the doomrc file ...")
      config = dofile(doomrc_path)
    end)

    if not loaded_doomrc then
      log.error("Error while loading the doomrc. Traceback:\n" .. err)
    end
  else
    log.warn("No doomrc.lua file found, falling to defaults")
    config = default_doomrc_values()
  end

  return config
end

return M
