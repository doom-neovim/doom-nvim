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
    "colorizer",          -- Show colors in neovim
    "editorconfig",       -- Support editorconfig files
    -- "gitsigns",           -- Show git changes in sidebar
    "illuminate",         -- Highlight other copies of the word you're hovering on
    "indentlines",        -- Show indent lines with special characters
    "range_highlight",    -- Highlight selected range from commands
    "todo_comments",      -- Highlight TODO: comments
    "doom_themes",        -- Extra themes for doom
    "leap",               -- Replace `s` with advanced leap.nvim motion plugin.

    -- UI Components
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

    -- Tools
    -- "dap",             -- Debug code through neovim
    "explorer",           -- An enhanced filetree explorer
    "firenvim",           -- Embed neovim in your browser
    "lazygit",            -- Lazy git integration
    "git",                -- git basic support
    "github",             -- github integration
    "diffview",           -- git diffview integration
    "neogit",          -- A git client for neovim
    "neorg",              -- Organise your life
    "plugins_reloader",   -- Watch local packages for changes during development
    "projects",           -- Quickly switch between projects
    "superman",        -- Read unix man pages in neovim
    -- "suda",            -- Save using sudo when necessary
    "telescope",          -- Fuzzy searcher to find files, grep code and more
    "whichkey",           -- An interactive sheet



    -- Molleweide
    "ai",
    "architext",
    -- "async_jobs",
    -- "audio",
    -- "autocmds",
    -- "awk",
    "binds",
    -- "binds_debug",
    -- "binds_make_fn_under_cursor_into_bind",
    -- "binds_mini_syntax",
    -- "char_counter",
    -- "clipboard",
    "cmdline",
    -- "code_outline",
    -- "codeql",
    -- "coderunner",
    "collaborate",
    -- "color_scheme_creation",
    "color_schemes",
    "colors",
    -- "community_configs",
    -- "competitive",
    -- "complementree",
    -- "create_cmds",
    -- "create_module_sync_root",
    -- "create_plugin",
    -- "create_snippet",
    -- "crypto",
    "cursor",
    -- "data_science",
    -- "debugging",
    -- "diagnostics",
    -- "diagrams",
    -- "dim_unused",
    -- "docker",
    "docs",
    -- "doom_module_formatting",
    -- "doom_queries_manager",
    -- "doom_user_settings_ui",
    "editing",
    -- "fennel",
    -- "figlet",
    -- "file_explorers",
    -- "filetype",
    -- "flutter",
    -- "folds",
    "formatting",
    -- "games",
    -- "gdb",
    "ghq",
    -- "google_docs",
    "gpg",
    -- "haskell",
    -- "help",
    -- "highlighting",
    -- "icons",
    -- "images",
    -- "increment",
    -- "indent",
    -- "kmonad",
    -- "lang_nav",
    -- "latex",
    -- "legend",
    -- "libmodal",
    "litee",
    -- "logging",
    -- "lsp",
    -- "lsp_semantinc_tokens",
    -- "lsp_testing",
    -- "lua_table_commands",
    -- "mappings",
    -- "markdown",
    -- "marks",
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
    -- "mouse",
    -- "move",
    -- "navigator",
    -- "nodejs",
    -- "nvim_luadev",
    -- "nvim_queries",
    -- "open_module_for_bind",
    -- "pandoc",
    -- "parse_module_cmd_args",
    "paths",
    -- "plugin_template",
    -- "plugins_fork",
    -- "plugins_local_reloader",
    -- "printer",
    -- "projects",
    "quickfix",
    -- "rayx",
    -- "read_file",
    -- "reaper_keys",
    "refactor",
    -- "refactor_fn_into_utils",
    -- "regex",
    -- "registers",
    -- "remote_dev",
    -- "rename",
    -- "repl",
    -- "repo_search",
    -- "ripgrep",
    -- "rust",
    -- "scheme_formatting",
    -- "scim",
    -- "scroll",
    "search_and_replace",
    -- "session",
    -- "snipets_create_edit",
    -- "snippets",
    -- "solidity",
    -- "sort",
    -- "spellcheck",
    -- "ssh",
    -- "startup",
    -- "statusline",
    -- "stenography",
    -- "surround",
    -- "tabs",
    -- "tabular",
    -- "telescope_doom_reloader",
    "telescope_extensions",
    -- "telescope_mappings_legend",
    -- "terminal_integration",
    -- "test",
    -- "testing",
    -- "tmux",
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
    "tweak",
    -- "ui",
    -- "ui_pipeline",
    -- "ui_toggle_components",
    -- "undo",
    -- "utilities",
    -- "vigoux_templar",
    -- "virtual_types",
    -- "websearch",
    -- "wildmenu",
    "windows",
    "wm",

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
  },
}

-- vim: sw=2 sts=2 ts=2 fdm=indent expandtab
