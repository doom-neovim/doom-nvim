-- doom_modules - Doom nvim module selection
--
-- The doom_modules controls what Doom nvim plugins modules are enabled and
-- what features are being used.
--
-- Comment out a plugin to enable it and comment a non-commented one to
-- disable and uninstall it.
--
-- NOTE: you can open the Doom nvim documentation by pressing `SPC d h`. You
-- will find a table of content where you will see a "Doomrc" section under the
-- "Configuration" one. In that section you will find a comprehensive list of
-- the available modules and all their supported flags.

local M = {}

M.source = debug.getinfo(1, "S").source:sub(2)

M.modules = {
  ui = {
    "dashboard",          -- Start screen
    -- "doom-themes",     -- Additional doom emacs' colorschemes
    -- "indentlines",     -- Show indent lines
    -- "show_registers",  -- popup that shows register contents
    "statusline",         -- Statusline
    "tabline",            -- Tabline, shows your buffers list at top
    "which-key",          -- Keybindings popup menu like Emacs' guide-key
    -- "zen",             -- Distraction free environment
    -- "illuminated",     -- Highlight other uses of the word under the cursor like VSC
  },
  doom = {
    -- "compiler",        -- Compile (and run) your code with just pressing three keys!
    -- "contrib",         -- Special plugins intended for Doom Nvim contributors (lua docs, etc)
    "neorg",              -- Life Organization Tool, used by Doom Nvim user manual
    -- "runner",          -- Open a REPL for the current language or run the current file
  },
  editor = {
    "autopairs",          -- Autopairs
    "auto-session",       -- A small automated session manager for Neovim
    "dap",                -- Debug Adapter Protocol
    -- "editorconfig",    -- EditorConfig support for Neovim
    "explorer",           -- Tree explorer
    "formatter",          -- File formatting
    "gitsigns",           -- Git signs
    "kommentary",         -- Comments plugin
    -- "linter",          -- Asynchronous linter, see errors in your code on the fly
    "lsp",                -- Language Server Protocols
    -- "minimap",         -- Code minimap, requires github.com/wfxr/code-minimap
    -- "ranger",          -- Ranger File Browser, requires ranger file browser
    "snippets",           -- Code snippets
    -- "symbols",         -- LSP symbols and tags
    "telescope",          -- Highly extendable fuzzy finder over lists
    -- "terminal",        -- Terminal for Neovim (NOTE: needed for runner and compiler)
    -- "trouble",         -- A pretty list to help you solve all the trouble your code is causing.
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
    "lua",                -- Support for our gods language
    -- "python +lsp",     -- Python support + lsp
    -- "ruby",            -- Look ma, I love the gems!

    -- "c",               -- Core dumped: segmentation fault
    -- "cpp",             -- C++ support
    -- "go",              -- Hello, gopher
    -- "haskell",         -- Because Functional programming is fun, isn't it?
    -- "java",            -- Java support
    -- "rust +lsp",       -- Let's get rusty!
    -- "scala",           -- Java, but good

    -- "comment",         -- Better annotations and comments
    -- "config",          -- Configuration files (JSON, YAML, TOML)
    -- "dockerfile",      -- Do you like containers, right?
    -- "terraform",       -- Terraform and HCL support
  },
  utilities = {
    -- "lazygit",         -- LazyGit integration for Neovim, requires LazyGit
    -- "neogit",          -- Magit for Neovim
    "range-highlight",    -- Hightlights ranges you have entered in commandline
    -- "suda",            -- Write and read files without sudo permissions
    -- "superman",        -- Read Unix man pages faster than a speeding bullet!
    -- "todo_comments",   -- Highlight, list and search todo comments in your projects
  },
  web = {
    -- "colorizer",       -- Fastest colorizer for Neovim
    -- "firenvim",        -- Requires firenvim browser extension; change fontsize by increasing guifontsize in doom_config
    -- "restclient",      -- A fast Neovim http client
  },
}

return M

-- vim: sw=2 sts=2 ts=2 fdm=indent noexpandtab
