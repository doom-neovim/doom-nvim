stds.nvim = {
    read_globals = { "vim", "jit" },
}
std = "lua51+nvim"

-- Rerun tests only if their modification time changed.
cache = true

-- NOTE: rules from 100...400 are specific for Neovim stuff, e.g. vim.opt
ignore = {
	"113",     -- Accessing an undefined global variable.
	"121",     -- Setting a read-only global variable.
	"122/vim", -- Setting a read-only field of a global variable.
	"143",     -- Accessing an undefined field of a global variable.
	"212/_.*", -- Unused argument, for variables with "_" prefix.
	"331",     -- Value assigned to a local variable is mutated but never accessed.
	"631",     -- Line is too long.
}

exclude_files = {
    "plugin/packer_compiled.lua"
}

-- vim: ft=lua
