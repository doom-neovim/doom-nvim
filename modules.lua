-- modules.lua - Doom nvim module selection
--
-- modules.lua controls what Doom nvim plugins modules are enabled and
-- what features are being used.
--
-- Uncomment a plugin to enable it and comment out to disable and uninstall it.

return {
  features = {
    -- Language features
    "annotations",        -- Code annotation generator
    "auto_install",       -- Auto install LSP providers
    "autopairs",          -- Automatically close character pairs
    "comment",            -- Adds keybinds to comment in any language
    "linter",             -- Linting and formatting for languages
    "lsp",                -- Code completion
    "snippets",           -- Code snippets for all languages

    -- Editor
    "auto_session",       -- Remember sessions between loads
    "colorizer",          -- Show colours in neovim
    "editorconfig",       -- Support editorconfig files
    "gitsigns",           -- Show git changes in sidebar
    "illuminate",         -- Highlight other copies of the word you're hovering on
    "indentlines",        -- Show indent lines with special characters
    "range_highlight",    -- Highlight selected range from commands
    "todo_comments",      -- Highlight TODO: comments

    -- UI
    "fidget",             -- Check status of LSP loading
    "tabline",            -- Tab bar buffer switcher
    "dashboard",          -- A pretty dashboard upon opening
    "trouble",            -- A pretty diagnostic viewer
    "statusline",         -- A pretty status line at the bottom of the buffer
    -- "minimap",         -- Shows current position in document

    -- Tools
    -- "dap",             -- Debug code through neovim
    "explorer",           -- An enhanced filetree explorer
    -- "firenvim",        -- Embed neovim in your browser
    "telescope",          -- Fuzzy searcher to find files, grep code and more
    "neorg",              -- Organise your life
    "whichkey",           -- An interactive sheet
    "projects",           -- Quickly switch between projects

    -- "doom_themes",     -- Extra themes for doom
    -- "lazygit",         -- Lazy git integration
    -- "neogit",          -- A git client for neovim
    -- "ranger",          -- File explorer in neovim (TODO: Test)
    -- "restclient",      -- Test HTTP requests from neovim (TODO: Test)
    -- "show_registers",  -- Show and navigate between registers
    -- "suda",            -- Save using sudo when necessary
    -- "superman",        -- Read unix man pages in neovim
    -- "symbols",         -- Navigate between code symbols using telescope
    -- "terminal",        -- Integrated terminal in neovim
    -- "zen",             -- Distractionless coding
  },
  langs = {
    -- Scripts
    "lua",
    "python",
    "bash",

    -- Web
    "javascript",
    "typescript",
    "css",
    "vue",
    "tailwindcss",

    -- Compiled
    "rust",
    "cpp",

    -- JIT
    "c_sharp",
    "kotlin",
    "java",

    "config",             -- JSON, YAML, TOML
  }
}

-- vim: sw=2 sts=2 ts=2 fdm=indent expandtab
