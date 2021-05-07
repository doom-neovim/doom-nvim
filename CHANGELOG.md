# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.0] - 2021-05-07

### Changed
- Plugins
  - Whichkey
    - now appears as a small window at the bottom (increase in screen real estate)
    - *NOTE: you can change the background color by tweaking `whichkey_bg` in `doomrc`*
  - Dashboard
    - Changed icons and Option names  
    - You now set your header/colors through `doomrc`
  - Tagbar / Nvim-tree
    - Default positions have changed (Nvim-tree will now open to the left by default)

### Fixed

- Telescope grep returning `nil`
- Whichkey triggering when pressing certain keys
- Minor bug fixes

### Removed

- Many hard coded config options
- Dashboard: removed messy code
- Telescope: `vimgrep_arguments` (returning `nil` on some machines)
- Whichkey: `Window: border, position. Layout: spacing`

### Added
- LSP symbol diagnostics (*check `doomrc`*) 
- Lspsaga (go to definition, references, hover_doc, etc)
- Better keybindings
- Tab completion
- Way more customization options to `doomrc`
- You can now easily add an `undodir` in `doomrc` (default = `false`)
- You now can change `new_file_split` to `false` in `doomrc` so `<Leader>fn` doesn't create a split


## [2.1.4] - 2021-05-04

### Fixed

- TreeSitter syntax highlighting and indentation

## [2.1.3] - 2021-05-03

### Removed

- Unused code in packer setup

### Fixed

- Some bugs in packer setup

## [2.1.2] - 2021-05-02

### Removed

- `Is_directory` function in `utils/`

### Fixed

- Squashed bugs in `Check_plugin` function
- Installation script will install packer.nvim in `start/` and not in `opt/`

## 2.1.1 - 2021-05-02

### Fixed

- Squashed a bug in packer setup
- Stop referencing autoload in docs

## [2.1.0] - 2021-05-02

### Added

- Now the `:messages` are logged automatically on exit, should provide a better debugging experience
- Plugins
  - Configurations
    - `devicons` configurations, set proper icons for certain filetypes (most of them related to web development)

### Changed

- Configurations
  - Better defaults
  - Breaking changes
    - doomrc is not using Vimscript anymore, please see the new doomrc format
- Plugins
  - Replaced
    - `indentLine` in favour of `indent-blankline.lua`
  - Updated
    - New `galaxyline` appearance, should look better now :)
    - `WhichKey` configurations, some improvements
    - `nvim-toggleterm` configurations, some improvements
    - Moved `dashboard` configurations to `lua/plugins/configs/nvim-dashboard.lua`
- Misc
  - Refact Doom Nvim README

### Deleted

- Doom autoload files (we are already _almost_ completely free from Vimscript!)
- `Start in insert` autocmd, not required anymore
- Some unused functions

### Fixed

- Some typos
- Squashed some bugs
- Lua style (global things to Capitalize), no more warns about that

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

[unreleased]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.4...HEAD
[2.1.4]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.3...v2.1.4
[2.1.3]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.2...v2.1.3
[2.1.2]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.0...v2.1.2
[2.1.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v0.2.0...v0.3.0
[1.0.0]: https://github.com/NTBBloodbath/doom-nvim/releases/tag/v1.0.0
