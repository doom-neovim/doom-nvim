---[[---------------------------------------------]]---
--     modules - Load Doom Nvim doom_modules.lua     --
--                 Author: NTBBloodbath              --
--                 License: GPLv2                    --
---[[---------------------------------------------]]---

local system = require("doom.core.system")
local log = require("doom.extras.logging")

local modules = {}

modules.modules = {
  ui = {
    "dashboard", -- Start screen
    -- "doom-themes",     -- Additional doom emacs' colorschemes
    -- "indentlines",     -- Show indent lines
    -- "show_registers",  -- popup that shows register contents
    "statusline", -- Statusline
    "tabline", -- Tabline, shows your buffers list at top
    "which-key", -- Keybindings popup menu like Emacs' guide-key
    -- "zen",             -- Distraction free environment
  },
  doom = {
    -- "compiler",        -- Compile (and run) your code with just pressing three keys!
    -- "neorg",           -- Life Organization Tool
    -- "runner",          -- Open a REPL for the current language or run the current file
  },
  editor = {
    "autopairs", -- Autopairs
    "auto-session", -- A small automated session manager for Neovim
    "dap", -- Debug Adapter Protocol
    -- "editorconfig",    -- EditorConfig support for Neovim
    "explorer", -- Tree explorer
    "formatter", -- File formatting
    "gitsigns", -- Git signs
    "kommentary", -- Comments plugin
    "lsp", -- Language Server Protocols
    -- "minimap",         -- Code minimap, requires github.com/wfxr/code-minimap
    -- "ranger",          -- Ranger File Browser, requires ranger file browser
    "snippets", -- LSP snippets
    "symbols", -- LSP symbols and tags
    "telescope", -- Highly extendable fuzzy finder over lists
    -- "terminal",        -- Terminal for Neovim (NOTE: needed for runner and compiler)
  },
  langs = {
    -- To enable the language server for a language just add the +lsp flag
    -- at the end, e.g. 'rust +lsp'. This will install the rust TreeSitter
    -- parser and rust-analyzer
    --
    -- "css",             -- CSS support
    -- "html",            -- HTML support
    -- "javascript",      -- JavaScript support
    -- "typescript",      -- TypeScript support

    -- "bash",            -- The terminal gods language
    -- "elixir",          -- Build scalable and maintainable software
    "lua", -- Support for our gods language
    -- "python +lsp",     -- Python support + lsp
    -- "ruby",            -- Look ma, I love the gems!

    -- "cpp",             -- C++ support
    -- "go",              -- Hello, gopher
    -- "haskell",         -- Because Functional programming is fun, isn't it?
    -- "java",            -- Java support
    -- "rust +lsp",       -- Let's get rusty!

    -- "config",          -- Configuration files (JSON, YAML, TOML)
    -- "dockerfile",      -- Do you like containers, right?
  },
  utilities = {
    -- "lazygit",         -- LazyGit integration for Neovim, requires LazyGit
    -- "neogit",          -- Magit for Neovim
    "range-highlight", -- hightlights ranges you have entered in commandline
    -- "suda",            -- Write and read files without sudo permissions
  },
  web = {
    -- "colorizer",       -- Fastest colorizer for Neovim
    -- "firenvim",        -- requires firenvim browser extension; change fontsize by increasing guifontsize in doom_config
    -- "restclient",      -- A fast Neovim http client
  },
}

modules.source = nil

log.debug("Loading Doom modules module ...")

-- Path cases:
--   1. /home/user/.config/doom-nvim/doom_modules.lua
--   2. stdpath('config')/doom_modules.lua
--   3. <runtimepath>/doom_modules.lua
local ok, ret = xpcall(dofile, debug.traceback, system.doom_configs_root .. "/doom_modules.lua")
if ok then
  modules.modules = ret.modules
  modules.source = ret.source
else
  ok, ret = xpcall(dofile, debug.traceback, system.doom_root .. "/doom_modules.lua")
  if ok then
    modules.modules = ret.modules
    modules.source = ret.source
  else
    ok, ret = xpcall(require, debug.traceback, "doom_modules")
    if ok then
      modules.modules = ret.modules
      modules.source = ret.source
    else
      log.error("Error while loading doom_modules.lua. Traceback:\n" .. ret)
    end
  end
end

return modules
