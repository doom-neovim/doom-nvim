-- modules.lua - Doom nvim module selection
--
-- modules.lua controls what Doom nvim plugins modules are enabled and
-- what features are being used.
--
-- Uncomment a plugin to enable it and comment out to disable and uninstall it.
-- Once done, restart doom-nvim and run `:PackerInstall`.

return {
  features = {
    -- Language features
    "annotations", -- Code annotation generator
    "auto_install", -- Auto install LSP providers
    "autopairs", -- Automatically close character pairs
    "comment", -- Adds keybinds to comment in any language
    "linter", -- Linting and formatting for languages
    "lsp", -- Code completion
    "extra_snippets", -- Code snippets for all languages

    -- Editor
    "auto_session", -- Remember sessions between loads
    "colorizer", -- Show colors in neovim
    "editorconfig", -- Support editorconfig files
    "gitsigns", -- Show git changes in sidebar
    "illuminate", -- Highlight other copies of the word you're hovering on
    "indentlines", -- Show indent lines with special characters
    "range_highlight", -- Highlight selected range from commands
    "todo_comments", -- Highlight TODO: comments
    -- "doom_themes",     -- Extra themes for doom

    -- UI Components
    "lsp_progress", -- Check status of LSP loading
    "tabline", -- Tab bar buffer switcher
    "dashboard", -- A pretty dashboard upon opening
    -- "trouble",         -- A pretty diagnostic viewer
    "statusline", -- A pretty status line at the bottom of the buffer
    -- "minimap",         -- Shows current position in document
    -- "terminal",        -- Integrated terminal in neovim
    -- "symbols",         -- Navigate between code symbols using telescope
    -- "ranger",          -- File explorer in neovim (TODO: Test)
    -- "restclient",      -- Test HTTP requests from neovim (TODO: Test)
    -- "show_registers",  -- Show and navigate between registers

    -- Tools
    -- "dap",             -- Debug code through neovim
    "repl", -- Interactive REPL in neovim
    "explorer", -- An enhanced filetree explorer
    -- "firenvim",        -- Embed neovim in your browser
    -- "lazygit",         -- Lazy git integration
    -- "neogit",          -- A git client for neovim
    "neorg", -- Organise your life
    "projects", -- Quickly switch between projects
    -- "superman",        -- Read unix man pages in neovim
    -- "suda",            -- Save using sudo when necessary
    "telescope", -- Fuzzy searcher to find files, grep code and more
    "whichkey", -- An interactive sheet
  },
  langs = {
    -- Scripts
    "lua",
    -- "python",
    -- "bash",
    -- "fish",
    -- "gdscript",
    -- "gdscript",
    -- "php",
    -- "ruby",

    -- Web
    -- "javascript",
    -- "typescript",
    -- "css",
    -- "vue",
    -- "tailwindcss",
    -- "svelte",

    -- Compiled
    -- "rust",
    -- "cc",
    -- "ocaml",
    -- "haskell",

    -- JIT
    -- "c_sharp",
    -- "kotlin",
    -- "java",

    -- "json",
    -- "yaml",
    -- "toml",
    -- "markdown",
    -- "terraform",       -- Terraform / hcl files support
    -- "dockerfile",
    -- "nix",             -- Nix declarations
  },
}

-- vim: sw=2 sts=2 ts=2 fdm=indent expandtab
