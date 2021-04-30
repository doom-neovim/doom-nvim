# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2021-04-30
### Added
- Configurations
    - `g:doom_autoload_last_session` variable
    - `g:doom_terminal_direction` variable
    - `g:doom_terminal_width` variable
    - `g:doom_terminal_height` variable
- Plugins
    - `auto-session`

### Changed
- Installation script
    - Now you can select the branch to use (main, develop)
- Lua migration
    - init
    - configs
    - plugins
- Implemented better custom plugins system
- Start using TreeSitter based indentation
- Plugins
    - Replaced
        - `Goyo` in favour of `TrueZen`
        - `leader-mapper` in favour of `WhichKey`
        - `Vista.vim` in favour of `SymbolsOutline`
        - `Neoformat` in favour of `format.nvim`
        - `nvim-autopairs` in favour of `pears.nvim`
    - Updated
        - `nvim-toggleterm` configurations
    - Other changes
        - `telescope.nvim` cannot be disabled anymore
- Keybindings
    - Refact some `<leader>` bindings
    - Use `:TZAtaraxis` as F6 key bind
    - New `:dr` map, easily create crash reports
- Misc
    - Cleaned some code hunk
    - Formatted all files
    - Refact changelog

### Deleted
    - Old Vimscript configs codebase
    - Plugins
        - Deleted `vim-polyglot` in favour of TreeSitter based
          syntax highlighting

### Fixed
    - Some bugs that I don't really remember
    - Squashed bugs on autoload functions

## 1.2.1 - 2021-03-30
### Added
- New branch `develop`

### Changed
- Improved installation script

## [1.2.0] - 2021-03-30
### Added
- Configurations
    - `g:doom_ts_parsers` variable
    - New key binding for toggle terminal
    - `doomrc` template with the default options values
- Basic implementation for `:checkhealth` command
- Plugins
    - `gitsigns`
    - `indentLine`
    - `nvim-lspinstall`
    - Some new colorschemes

### Changed
- Improved `:DoomUpdate` command
- Some minor changes more under the hood
- Plugins
    - `signify` in favor of `gitsigns`

### Fixed
    - Squashed some bugs

## 1.1.0 - 2021-03-22
### Added
- `Doom` section to `vim-leader-guide` plugin,
  see |doom_nvim_commands_keybindings|
- `:DoomUpdate` command,
  see |doom_nvim_commands|
- `g:doom_autosave_sessions`,
  see |doom_nvim_options|

## [1.0.0] - 2021-03-19
- Initial stable release

[Unreleased]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v0.2.0...v0.3.0
[1.0.0]: https://github.com/NTBBloodbath/doom-nvim/releases/tag/v1.0.0
