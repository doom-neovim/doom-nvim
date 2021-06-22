# Utils

Herein lies all the Doom utility functions and variables.

## Variables

- `doom_version` - Doom Nvim version.
- `doom_root` - Doom Nvim root directory.
- `doom_logs` - Doom Nvim logs file path.
- `doom_report` - Doom Nvim crash report path.

## Functions

- `map` - Wrapper for `nvim_set_keymap`.
- `create_augroups` - Autocommands wrapper for Lua.
- `is_empty` - Check if a string is empty or nil.
- `has_value` - Search if a table have a value.
- `try` and `catch` - Try/Catch for error handling.
- `get_os` - Get the current OS using LuaJIT.
