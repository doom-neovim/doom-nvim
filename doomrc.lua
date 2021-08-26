-- doomrc - Doom nvim configurations file
--
-- The doomrc controls what Doom nvim plugins modules are enabled and what
-- features are being used.
--
-- Comment out a plugin to enable it and comment a non-commented one to
-- disable and uninstall it.
--
-- NOTE: you can open the Doom nvim documentation by pressing `SPC d h`. You
-- will find a table of content where you will see a "Doomrc" section under the
-- "Configuration" one. In that section you will find a comprehensive list of
-- the available modules and all their supported flags.

local doom = {
  ui = {
    "dashboard",          -- Start screen
    -- "doom-themes",     -- Additional doom emacs' colorschemes
    "statusline",         -- Statusline
    "tabline",            -- Tabline, shows your buffers list at top
    -- "zen",             -- Distraction free environment
    "which-key",          -- Keybindings popup menu like Emacs' guide-key
    -- "indentlines",     -- Show indent lines
    -- "show_registers",  -- popup that shows register contents
  },
  doom = {
    -- "neorg",           -- Life Organization Tool
    -- "runner",          -- Open a REPL for the current language or run the current file
    -- "compiler",        -- Compile (and run) your code with just pressing three keys!
  },
  editor = {
    "auto-session",       -- A small automated session manager for Neovim
    "terminal",           -- Terminal for Neovim (NOTE: needed for runner and compiler)
    "explorer",           -- Tree explorer
    -- "ranger",          -- Ranger File Browser, requires ranger file browser
    "symbols",            -- LSP symbols and tags
    -- "minimap",         -- Code minimap, requires github.com/wfxr/code-minimap
    "gitsigns",           -- Git signs
    "telescope",          -- Highly extendable fuzzy finder over lists
    "formatter",          -- File formatting
    "autopairs",          -- Autopairs
    -- "editorconfig",    -- EditorConfig support for Neovim
    "kommentary",         -- Comments plugin
    "lsp",                -- Language Server Protocols
    "dap",                -- Debug Adapter Protocol
    "snippets",           -- Snippets
  },
  langs = {
    -- To enable the language server for a language just add the +lsp flag
    -- at the end, e.g. 'rust +lsp'. This will install the rust TreeSitter
    -- parser and rust-analyzer
    --
    -- "html",            -- HTML support
    -- "css",             -- CSS support
    -- "javascript",      -- JavaScript support
    -- "typescript",      -- TypeScript support
    -- "bash",            -- The terminal gods language
    -- "python +lsp",     -- Python support + lsp
    -- "ruby",            -- Look ma, I love the gems!
    "lua",                -- Support for our gods language
    -- "elixir",          -- Build scalable and maintainable software
    -- "haskell",         -- Because Functional programming is fun, isn't it?

    -- "rust +lsp",       -- Let's get rusty!
    -- "go",              -- Hello, gopher
    -- "cpp",             -- C++ support
    -- "java",            -- Java support

    -- "config",          -- Configuration files (JSON, YAML, TOML)
    -- "dockerfile",      -- Do you like containers, right?
  },
  utilities = {
    -- "suda",            -- Write and read files without sudo permissions
    -- "lazygit",         -- LazyGit integration for Neovim, requires LazyGit
    -- "neogit",          -- Magit for Neovim
    -- "colorizer",       -- Fastest colorizer for Neovim
    "range-highlight",    -- hightlights ranges you have entered in commandline
  },
  web = {
    -- "restclient",      -- A fast Neovim http client
    -- "firenvim",        -- requires firenvim web extension; change fontsize by increasing guifontsize in doom_config
    -- "colorizer",       -- Fastest colorizer for Neovim
  }
}

return doom
