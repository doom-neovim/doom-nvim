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
    "search_and_replace", -- Binds for search and replace
    -- "mouse",
    "cursor",
    -- "tabs",
    -- "scroll",
    -- "registers",
    -- "marks",
    -- "undo",
    -- "folds",

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

    ------------------------------------------------------------------
    -- ::: TOOLS ::: --
    ------------------------------------------------------------------

    "ai",
    -- "dap",             -- Debug code through neovim
    "gpg",
    -- "ssh",
    "collaborate",        -- Google docs collaborative editing.
    "explorer",           -- An enhanced filetree explorer
    "firenvim",           -- Embed neovim in your browser
    "lazygit",            -- Lazy git integration
    -- "gitsigns",           -- Show git changes in sidebar
    "git",                -- git basic support
    "github",             -- github integration; requires `litee` module under `Editor`
    "diffview",           -- git diffview integration
    "neogit",          -- A git client for neovim
    "neorg",              -- Organise your life
    "plugins_reloader",   -- Watch local packages for changes during development
    "projects",           -- Quickly switch between projects
    -- "sort",            -- extra binds that help with sorting lines/objects
    "superman",        -- Read unix man pages in neovim
    -- "suda",            -- Save using sudo when necessary
    "telescope",          -- Fuzzy searcher to find files, grep code and more
    "whichkey",           -- An interactive sheet
    "refactor",           -- Code refactoring
  -- "scim",              -- Spreadsheets

    ------------------------------------------------------------------
    -- ::: MISC ::: --
    ------------------------------------------------------------------

    "color_schemes",        -- if you want to play around with new color schemes
    -- "crypto",            -- Crypto currency stuff
    -- "diagrams",
    -- "games",
    -- "solidity",          -- ethereum lang
    -- "tabular",
    -- "websearch",
    -- "data_science",



    ------------------------------------------------------------------
    -- ::: MOLLEWEIDE ::: --
    ------------------------------------------------------------------

    "architext", -- todo
    "binds",
    "colors",
    "docs",
    "editing",
    "formatting",
    "ghq",
    "paths",
    "telescope_extensions",
    "tweak",
    "windows",
    "wm",
    -- "tmux",

    -- Molleweide
    -- "async_jobs",
    -- "audio",
    -- "autocmds",
    -- "awk",
    -- "binds_debug",
    -- "binds_make_fn_under_cursor_into_bind",
    -- "binds_mini_syntax",
    -- "char_counter",
    -- "clipboard",
    -- "code_outline",
    -- "codeql",
    -- "coderunner",
    -- "color_scheme_creation",
    -- "community_configs",
    -- "competitive",
    -- "complementree",
    -- "create_cmds",
    -- "create_module_sync_root",
    -- "create_plugin",
    -- "create_snippet",
    -- "debugging",
    -- "diagnostics",
    -- "dim_unused",
    -- "docker",
    -- "doom_module_formatting",
    -- "doom_queries_manager",
    -- "doom_user_settings_ui",
    -- "figlet",
    -- "file_explorers",
    -- "filetype",
    -- "flutter",
    -- "gdb",
    -- "google_docs",
    -- "haskell",
    -- "help",
    -- "highlighting",
    -- "icons",
    -- "images",
    -- "increment",
    -- "indent",
    -- "kmonad",
    -- "lang_nav",
    -- "legend",
    -- "libmodal",
    -- "logging",
    -- "lsp_semantinc_tokens",
    -- "lsp_testing",
    -- "lua_table_commands",
    -- "mappings",
    -- "markdown",
    -- "math_calculator",
    -- "module_create_edit",
    -- "module_disable",
    -- "module_manager",
    -- "module_merge",
    -- "module_package_configs",
    -- "module_package_toggle_fork",
    -- "module_refactor_any_extra_vars_into_settings",
    -- "module_remove",
    -- "module_syntax_enforce",
    -- "modules_edit",
    -- "modules_move_component",
    -- "monitor_mappings",
    -- "move",
    -- "navigator",
    -- "nodejs",
    -- "nvim_luadev",
    -- "nvim_queries",
    -- "open_module_for_bind",
    -- "pandoc",
    -- "parse_module_cmd_args",
    -- "plugin_template",
    -- "plugins_fork",
    -- "plugins_local_reloader",
    -- "printer",
    -- "projects",
    -- "rayx",
    -- "read_file",
    -- "reaper_keys",
    -- "refactor_fn_into_utils",
    -- "regex",
    -- "remote_dev",
    -- "rename",
    -- "repl",
    -- "repo_search",
    -- "ripgrep",
    -- "scheme_formatting",
    -- "session",
    -- "snipets_create_edit",
    -- "snippets",
    -- "spellcheck",
    -- "startup",
    -- "statusline",
    -- "stenography",
    -- "telescope_doom_reloader",
    -- "telescope_mappings_legend",
    -- "terminal_integration",
    -- "test",
    -- "testing",
    -- "todo",
    -- "ts_context",
    -- "ts_docs",
    -- "ts_jump_2_func",
    -- "ts_jump_to_module_part",
    -- "ts_lang_detect",
    -- "ts_mirror_doom_globals",
    -- "ts_mode",
    -- "ts_motions",
    -- "ts_navigation",
    -- "ts_playground",
    -- "ts_plugins",
    -- "ts_query_monitor",
    -- "ts_rainbow",
    -- "ts_refactor",
    -- "ts_syntax",
    -- "ts_testing",
    -- "ts_testing_locals",
    -- "ts_textobjects",
    -- "ts_treehopper",
    -- "ui",
    -- "ui_pipeline",
    -- "ui_toggle_components",
    -- "utilities",
    -- "vigoux_templar",
    -- "virtual_types",

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
  },
}

-- vim: sw=2 sts=2 ts=2 fdm=indent expandtab
