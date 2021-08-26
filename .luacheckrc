stds.nvim = {
  globals = {
    vim = { fields = { "g" } },
    table = { fields = { "unpack" } },
    package = { fields = { "searchers" } },
  },
  read_globals = {
    "vim",
    "jit",
    "packer_plugins",
  },
}
std = "lua51+nvim"

-- Rerun tests only if their modification time changed.
cache = true

-- NOTE: rules from 200...400 are specific for Neovim stuff, e.g. vim.opt
ignore = {
  "212/_.*", -- Unused argument, for variables with "_" prefix.
  "331", -- Value assigned to a local variable is mutated but never accessed.
  "631", -- Line is too long.
}

exclude_files = {
  "plugin/packer_compiled.lua",
}

-- vim: ft=lua sw=2 ts=2
