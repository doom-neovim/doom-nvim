-- modules.lua - Doom nvim module selection
--
-- modules.lua controls what Doom nvim plugins modules are enabled and
-- what features are being used.
--
-- Uncomment a plugin to enable it and comment out to disable and uninstall it.

-- TODO: REDO COMMENT HEADERS WITH FIGLET

return {
  features = {

    ------------------------------------------------------------------
    -- ::: LANGUAGE FEATURES ::: --
    ------------------------------------------------------------------

    "annotations",        -- Code annotation generator
    "auto_install",       -- Auto install LSP providers
    "autopairs",          -- Automatically close character pairs
    "comment",            -- Adds keybinds to comment in any language
    "linter",             -- Linting and formatting for languages
    "lsp",                -- Code completion
    "snippets",           -- Code snippets for all languages
    "context",            -- Provides visual context via Treesitter
    "args",               -- Provides highlighting and tools for managing function args
    "textobjects",
    "comments_frame",    -- Create big comments with a nice frame
    "endwise",      -- ??
    "ts_plugins",      -- walk through

    ------------------------------------------------------------------
    -- ::: EDITOR ::: --
    ------------------------------------------------------------------

    "auto_session",       -- Remember sessions between loads
    "colorizer",          -- Show colors in neovim
    "editorconfig",       -- Support editorconfig files
    "illuminate",         -- Highlight other copies of the word you're hovering on
    "indentlines",        -- Show indent lines with special characters
    "range_highlight",    -- Highlight selected range from commands
    "todo_comments",      -- Highlight TODO: comments
    "doom_themes",        -- Extra themes for doom
    "litee",              -- Litee IDE suite
    "leap",               -- Replace `s` with advanced leap.nvim motion plugin.
    "surround",           -- Surround text objects, eg. {([])}
    "cursor",
    -- "mouse",           -- ???
    -- "gestures",        -- Mouse gestures
    -- "tabs",            -- ???
    -- "scroll",
    "registers",
    -- "yank",            -- Improved yank functionalities, experimental plugin `yanky.nvim`
    "marks",
    -- "undo",
    -- "folds",
    -- "increment",       --  tools for incrementing stuff
    -- "clipboard",
    -- "regex",           -- Regex tools
    -- "help",            -- Support for help with binds and stuff
    -- "printer",
    -- "sort",            -- extra binds that help with sorting lines/objects
    -- "logging",         -- binds n stuff
    -- "buffers",
    -- "readline",        -- ???
    -- "filetype",        -- ???
    -- "make_inclusive",  -- Make various binds/plugins inclusive, ie. include cursor position in eg `f/F`

    ------------------------------------------------------------------
    -- ::: UI COMPONENTS ::: --
    ------------------------------------------------------------------

    "dui",                -- Browse config and modules with Telescope
    "lsp_progress",       -- Check status of LSP loading
    "tabline",            -- Tab bar buffer switcher
    "dashboard",          -- A pretty dashboard upon opening
    "trouble",         -- A pretty diagnostic viewer
    -- "statusline",         -- A pretty status line at the bottom of the buffer
    "minimap",         -- Shows current position in document
    "terminal",        -- Integrated terminal in neovim
    "symbols",         -- Navigate between code symbols using telescope
    "ranger",          -- File explorer in neovim (TODO: Test)
    "restclient",      -- Test HTTP requests from neovim (TODO: Test)
    "show_registers",  -- Show and navigate between registers
    "cmdline",         -- Floating cmdline at cursor
    -- "wildmenu",
    "quickfix",         -- Extra quickfix capabilitieS
    -- "images",        -- Image support
    -- "legend",        -- ???
    -- "vim_ui",            -- improved `vim.ui`
    "virtual_types", -- ???
    -- "code_outline",
    -- "transparent"

    ------------------------------------------------------------------
    -- ::: VCS / GIT ::: --
    ------------------------------------------------------------------

    -- "gitsigns",           -- Show git changes in sidebar
    "git",                -- git basic support
    "github",             -- github integration; requires `litee` module under `Editor`
    "diffview",           -- git diffview integration
    "neogit",          -- A git client for neovim
    "ghq",                -- Support for `qhq` repo manager
    -- "repo_search",     -- Browse repos in Telescope.

    ------------------------------------------------------------------
    -- ::: TRANSFORM ::: --
    ------------------------------------------------------------------

    "search_and_replace", -- Binds for search and replace
    "architext", -- todo


    ------------------------------------------------------------------
    -- ::: TOOLS ::: --
    ------------------------------------------------------------------

    "ai",
    -- "dap",             -- Debug code through neovim
    "gpg",
    -- "ssh",
    "collaborate",        -- Google docs collaborative editing.
    -- "docker",          -- Docker tools
    "explorer",           -- An enhanced filetree explorer
    "firenvim",           -- Embed neovim in your browser
    "lazygit",            -- Lazy git integration
    "neorg",              -- Organise your life
    -- "pandoc",
    "plugins_reloader",   -- Watch local packages for changes during development
    "projects",           -- Quickly switch between projects
    -- "remote_dev",      -- ???
    "superman",        -- Read unix man pages in neovim
    -- "tmux",               -- ???
    -- "suda",            -- Save using sudo when necessary
    "telescope",          -- Fuzzy searcher to find files, grep code and more
    "whichkey",           -- An interactive sheet
    "refactor",           -- Code refactoring
    -- "ripgrep",
    -- "flutter",
    -- "markdown_tools",  -- ??
    -- "google_docs",

    ------------------------------------------------------------------
    -- ::: TABULAR ::: --
    ------------------------------------------------------------------

    -- "scim",              -- Spreadsheets
    -- "tabular",           -- Extended support for managing tabular data

    ------------------------------------------------------------------
    -- ::: MISC ::: --
    ------------------------------------------------------------------

    "telescope_extensions", -- move into categories
    -- "audio",
    -- "crypto",            -- Crypto currency stuff
    -- "rename",            -- ??
    -- "spellcheck",
    -- "diagrams",
    -- "competitive",
    -- "libmodal",          -- Tool for creating custom modes
    -- "icons",             -- Extended various icons support
    -- "figlet",            -- figlet fonts editor
    -- "kmonad",            -- Support for kmonad keyboard remapper
    -- "navigator",         -- ???
    -- "games",
    -- "websearch",
    -- "data_science",
    -- "stenography",
    -- "statusline_misc",
    -- "utilities",         -- ??
    -- "math_calculator",



    ------------------------------------------------------------------
    -- ::: MOLLEWEIDE ::: --
    ------------------------------------------------------------------

    "binds",
    "colors",
    "docs",
    "editing",
    "formatting",
    "paths",
    "tweak",
    "windows",
    "wm",
    -- "tmux",

    ------------------------------------------------------------------
    -- ::: HOUSE CLEANING ::: --
    ------------------------------------------------------------------

    -- Molleweide
    -- "async_jobs",
    -- "autocmds",
    -- "awk",
    -- "binds_debug",
    -- "binds_make_fn_under_cursor_into_bind",
    -- "binds_mini_syntax",
    -- "char_counter",
    -- "codeql",
    -- "coderunner",
    -- "color_scheme_creation",
    -- "community_configs",
    -- "create_cmds",
    -- "create_module_sync_root",
    -- "create_plugin",
    -- "create_snippet",
    -- "debugging",
    -- "diagnostics",
    -- "dim_unused",
    -- "doom_module_formatting",
    -- "doom_queries_manager",
    -- "doom_user_settings_ui",
    -- "file_explorers",
    -- "gdb",
    -- "highlighting",
    -- "indent",
    -- "lang_nav",
    -- "lsp_semantinc_tokens",
    -- "lsp_testing",
    -- "lua_table_commands",
    -- "mappings",
    -- "nvim_luadev",
    -- "nvim_queries",
    -- "open_module_for_bind",
    -- "parse_module_cmd_args",
    -- "plugin_template",
    -- "plugins_fork",
    -- "plugins_local_reloader",
    -- "rayx",
    -- "read_file",
    -- "reaper_keys",
    -- "refactor_fn_into_utils",
    -- "repl",
    -- "snipets_create_edit",
    -- "startup",
    -- "telescope_doom_reloader",
    -- "telescope_mappings_legend",
    -- "test",
    -- "testing",
    -- "todo",
    -- "ts_jump_2_func",
    -- "ts_jump_to_module_part",
    -- "ts_mirror_doom_globals",
    -- "ts_navigation",
    -- "ts_query_monitor",
    -- "ts_testing",
    -- "ts_testing_locals",
    -- "ts_treehopper",
    -- "ui",
    -- "ui_pipeline",
    -- "ui_toggle_components",
    -- "vigoux_templar",

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
    "cc",

    -- JIT
    -- "c_sharp",
    -- "kotlin",
    -- "java",

    "config",          -- JSON, YAML, TOML
    "markdown",

    -- "fennel",
    -- "latex",
    -- lisp
    -- "solidity",          -- ethereum lang
  },
  themes = {
    -- "apprentice",
    -- "aquarium",
    -- "ariake",
    "aurora",
    -- "base16",
    -- "blue_moon",
    -- "boo",
    -- "calvera",
    -- "catpuccino",
    -- "cobalt",
    -- "codeschool",
    -- "dracula",
    -- "edge",
    -- "everforest",
    -- "falcon",
    "fly",
    "github",
    -- "gloombuddy",
    "gruvbox",
    -- "gruvbox-baby",
    -- "gruvbox-material",
    "gruvbuddy",
    -- "gruvy",
    -- "hybrid",
    -- "jellybeans",
    -- "kanagawa",
    -- "kosmikoa",
    -- "kyoto",
    "material",
    -- "modus",
    -- "monochrome",
    "monokai",
    -- "moonlight",
    -- "neon",
    "nightfox",
    "nord",
    -- "nordic",
    -- "nvcode",
    -- "nvim_deus",
    -- "oak",
    "oceanic_next",
    -- "omni",
    -- "one",
    -- "one_monokai",
    -- "onebuddy",
    -- "onedark",
    -- "onedarkpro",
    -- "onenord",
    -- "papadark",
    -- "rasmus",
    -- "rdark",
    -- "roshivim",
    "solarized",
    "sonokai",
    -- "space",
    -- "substrata",
    -- "sunflower",
    -- "tokyodark",
    "tokyonight",
    -- "uwu",
    -- "vim_code_dark",
    -- "vimdark",
    -- "vn_night",
    -- "vscode",
    -- "xresources",
    -- "zenbones",
    -- "zephyr",
    -- "zephyrium",
  }
}

-- vim: sw=2 sts=2 ts=2 fdm=indent expandtab




