-- modules.lua - Doom nvim module selection
--
-- modules.lua controls what Doom nvim plugins modules are enabled and
-- what features are being used.
--
-- Uncomment a plugin to enable it and comment out to disable and uninstall it.

return {
  features = {
    "auto_session",
    "autopairs",
    "colorizer",
    -- "dap",
    "dashboard",
    -- "doom_themes",
    "editorconfig",
    -- "explorer",
    -- "firenvim",
    -- "formatter",
    "gitsigns",
    "illuminate",
    "indentlines",
    "comment",
    -- "lazygit",
    "linter",
    "lsp",
    -- "minimap",
    -- "neogit",
    -- "neorg",
    "range_highlight",
    -- "ranger",
    -- "restclient",
    -- "show_registers",
    "snippets",
    "statusline",
    "projects",
    -- "suda",
    -- "superman",
    -- "symbols",
    "auto_install",
    "annotations",
    "tabline",
    "telescope",
    -- "terminal",
    "todo_comments",
    "trouble",
    "whichkey",
    -- "zen",
  },
  langs = {
    "lua",
    "python",

    "javascript",
    "typescript",
    "css",
    "vue",
    "tailwindcss",

    "rust",
    "cpp",
    "c_sharp",
    "bash",
  }
}

-- vim: sw=2 sts=2 ts=2 fdm=indent expandtab
