# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.1.1] - 2021-09-02

### Fixed

- Updated bufferline configs to match the new breaking changes
- Updated Neorg treesttier parser files to be able to successfully compile it
- Properly require logging on utils module

## [3.1.0] - 2021-08-26

### Added

- Options field to `doom_config.lua`, see [#62](https://github.com/NTBBloodbath/doom-nvim/pull/62)
- New prompt for editing doom configurations
- Better internal errors handling
- Allow to use options (e.g. silent) in the custom mappings
- Custom settings defined on `doom_config.lua` are automatically reloaded
- `SPC - d - l` keybinding for manually reload configurations
- Windows support (note that some plugins does not work well on Windows and that's not a doom issue!)
- `SPC - d - s` keybinding now offers a live preview for the colorschemes
- `tsx` treesitter parser is now installed alongside with the typescript one, see [#84](https://github.com/NTBBloodbath/doom-nvim/issues/84)
- Allow to override default keymappings
- Quick save with `SPC - v / m`
- Jump keybindings on which-key
- Keybindings to move lines (`Alt + j / k`)
- `win_width` option, for automatically setting the windows width
- You can now add your doom-nvim configurations to your dotfiles without having to use submodules!
    See [#79](https://github.com/NTBBloodbath/doom-nvim/issues/79)
- Plugins:
  - New plugin: treesitter companion plugins (autotag, docs, etc)
  - New plugin: nvim-mapper, a keybindings cheatsheet
  - New plugin: DAP (Debugging Adapter Protocol) support
  - New plugin: trouble, better quickfix window
  - New plugin: todo-comments.nvim, better TODO comments
  - New plugin: superman, man pages integration
  - New plugin: ranger, file browser integration
  - New plugin: firenvim, use Neovim in your favorite web browser!
  - New plugin: registers.nvim, show contents of each register on a popup window
  - Added more dynamic color palettes to galaxyline (e.g. nord, dracula, tokyonight)

### Changed

- Assume `~/.config/nvim` rather than `~/.config/doom-nvim`, see [#41](https://github.com/NTBBloodbath/doom-nvim/pull/41)
- Autocommands and keybindings now lives in `doom.extras` instead of `doom.core`
- Use a custom toggleterm instance for running and compiling code
- `<leader><space>` keybind is now `<leader>` + \`
- Format files before saving them instead of saving and formatting later
- Improved crash report (`SPC - d - R`) output
- undodir is now located at `~/.local/share/nvim`
- We have adopted a more saner and common coding style:
  - Spaces over tabs
  - Two spaces for indentation
- Plugins:
  - Changed some packer defaults for cloning, should speed up the cloning step with heavy size plugins like plenary
  - Changed kommentary lazy-loading event
  - Changed nvim-compe lazy-loading event
  - Improved how which-key plugin is being lazy-loaded
  - Updated TrueZen configurations
  - Updated gitsigns configurations
  - Lua LSP configurations are now handled by lua-dev.nvim plugin
  - session-lens was replaced by persistence.nvim
  - Improved some dashboard icons
  - indent-blankline character is now full height
  - Saner telescope configurations

### Fixed

- Respect `XDG_CONFIG_HOME` environment variable
- Plugins:
  - Occasional bug with autosessions
  - Properly lazy-load TrueZen
  - Use GCC compiler for haskell treesitter parser
  - bufferline will not be shown when:
    1. Only one buffer is opened
    2. While being in the dashboard
  - Add extra whitespace to some icons on galaxyline
  - Disable indent-blankline on norg files

### Deleted

- "Async" logic, it was not true async so we don't need it anymore
- Installer, doom-nvim can be installed with just two commands. Now you can have truly power over
    the installation process and a very transparent installation
- Unneeded `:checkhealth` add-on
- Plugins:
  - lspsaga, we are now using the built-in functionalities for LSP (hover doc, etc)

## [3.0.13] - 2021-08-24

### Fixed

- Use `stdpath("config")` for configuration paths instead of `~/.config/doom-nvim` because doom-nvim is actually symlinked, respect `XDG_CONFIG_HOME` (see [#101](https://github.com/NTBBloodbath/doom-nvim/pull/101))
- Update `<leader>dc` to match new config setup, ref [#101](https://github.com/NTBBloodbath/doom-nvim/pull/101). See [#102](https://github.com/NTBBloodbath/doom-nvim/pull/102)

## [3.0.12] - 2021-08-22

### Fixed

- Proper conditional for triggering dashboard-nvim plugin, check if it's in the packer_plugins table

## [3.0.11] - 2021-08-20

### Fixed

- Added missing `undodir` option

## [3.0.10] - 2021-08-20

### Fixed

- `undodir` was not working as expected

## [3.0.9] - 2021-08-04

### Fixed

- We're not lazy-loading `editorconfig` plugin anymore
- Added missing `neogit` entry in the plugins module
- `DoomUpdate` and `DoomRollback` not working in some Linux distributions
- Some visual bugs in the installer script

## [3.0.8] - 2021-07-25

### Fixed

- Properly lazy-load `TrueZen.nvim`

## [3.0.7] - 2021-07-13

### Fixed

- Properly lazy-load `format.nvim`
- Stop lazy-loading `friendly-snippets`

## [3.0.6] - 2021-07-13

### Fixed

- Added `neorg` to completion sources
- Properly setup for `LuaSnip` + `friendly-snippets`

## [3.0.5] - 2021-07-13

### Fixed

- Do not try to automatically install servers on start if the lspinstall plugin
  is not loaded
- Set termguicolors on start instead of wait for the UI module, avoid a strange
  error that I was having with packer

## [3.0.4] - 2021-07-13

### Fixed

- `doom-themes` plugin was loaded incorrectly
- Custom keymaps were not working in the `doom_config.lua` file

## [3.0.3] - 2021-07-12

### Changed

- Reverted [3.0.2] changes

## [3.0.2] - 2021-07-12

### Fixed

- Temporarily reverted `LuaSnip` to a previous commit to avoid issues with it.

## [3.0.1] - 2021-07-11

### Fixed

- Added some missing `<CR>` at the end of some `SPC` keybindings.

## [3.0.0] - 2021-07-11

### Added

- `:DoomRollback` command, easily rollback to a previous Doom Nvim version
  (main branch, a.k.a stable) or a previous commit (development branch).
- Dynamic statusline colors (WIP)
- More automation, plugins configurations will automatically take effect
  and the plugins will be automatically installed or uninstalled too, say bye
  to `PackerClean` and `PackerInstall` commands!
- The language servers can be automatically installed now by adding a `+lsp`
  flag in the `doomrc` languages field, e.g. for adding `rust` support and adding
  `rust-analyzer`: `'rust +lsp'`.
- Plugins:
  - Added `neorg`, `range-highlight`, `neogit` and more plugins!
  - Added initial built-in plugins for compiling and running your projects,
    see [modules](./docs/modules.md) for more information.

### Changed

- Our `doom-one` colorscheme have been rewritten and is now pure Lua!
- Reduced average startuptime from 400ms to 40ms (depends on the hardware!)
- Vim macros can be optionally disabled now, see related issue: #31
- Doom Nvim has been restructured, it's more robust and maintainable now.
- No more non-sense global wrappers around the Neovim Lua API, everything
  should have their own scope.
- Our `:DoomUpdate` command is now better, say bye to those annoying merging
  issues when there were huge changes.
- New statusline look and feel
- New logging system powered by [vlog](https://github.com/tjdevries/vlog).
- `packer.nvim` bootstrapping is now handled internally.
- Plugins:
  - We are now using `bufferline` instead of `barbar.nvim`.
  - We are now using `rest.nvim` as our HTTP client instead of `dot-http`.
  - We are now using `LuaSnip` + `friendly-snippets` instead of `snippets.nvim`.

### Deleted

- LSP kind plugin, the symbols kinds can be managed with the Lua API.

### Fixed

- Some issues on first launch related to plugins.

## [2.3.6] - 2021-07-11

### Fixed

- `nvim-telescope` plugin was not showing the files names (#34)

## [2.3.5] - 2021-07-08

### Changed

- use `/usr/bin/env bash` to make installer more portable
- Stop using a custom `packer.nvim` branch
- Relicense project to `GPLv2`

### Fixed

- `nvim-compe` keybinds mappings
- `nvim-telescope` plugin breaking changes, updated configurations

## [2.3.4] - 2021-07-03

### Changed

- Removed `logs/doom.log` and added it to `gitignore` (#27)

### Fixed

- `nvim-telescope` plugin breaking changes, updated configurations
- `indent-blankline` plugin lua branch removal notice, moved to master branch (#27)

## [2.3.3] - 2021-07-01

### Changed

- Revert autopairs plugin from `pears.nvim` to `nvim-autopairs` because of pears issues

### Fixed

- `nvim-tree` plugin is now using its new keybindings syntax

## [2.3.2] - 2021-05-20

### Added

- Configurations
  - `auto_install_plugins` option

### Changed

- Use `fix/premature-display-opening` branch in packer (temporal)
- Cleaned `plugins/init.lua` code
- Reverted [2.1.5] changes related to how packer is installed

### Fixed

- Plugins installation on fresh installation

## [2.3.1] - 2021-05-18

### Fixed

- Fix typos in custom plugins example
- Fix custom plugins enabling/disabling

## [2.3.0] - 2021-05-18

### Added

- Configurations
  - `complete_size` option
  - `complete_transparency` option

### Changed

- Organized doomrc

### Deleted

- Plugins
  - `focus`

## [2.2.0] - 2021-05-08

### Added

- LSP symbol diagnostics (_check `doomrc`_)
- Lspsaga (go to definition, references, hover_doc, etc)
- Better keybindings
- Tab completion
- Way more customization options to `doomrc`
- You can now easily add an `undodir` in `doomrc` (default = `false`)
- You now can change `new_file_split` to `false` in `doomrc` so `<Leader>fn` doesn't create a split

### Changed

- Plugins
  - Whichkey
    - now appears as a small window at the bottom (increase in screen real estate)
    - _NOTE: you can change the background color by tweaking `whichkey_bg` in `doomrc`_
  - Dashboard
    - Changed icons and Option names
    - You now set your header/colors through `doomrc`
  - Tagbar / Nvim-tree
    - Default positions have changed (Nvim-tree will now open to the left by default)
- Improvements to loading optional doom plugins

### Deleted

- Many hard coded config options
- Dashboard: removed messy code
- Telescope: `vimgrep_arguments` (returning `nil` on some machines)
- Whichkey: `Window: border, position. Layout: spacing`

### Fixed

- Telescope grep returning `nil`
- Whichkey triggering when pressing certain keys
- Minor bug fixes

## [2.1.5] - 2021-05-04

### Changed

- Installation script will not install packer anymore, it'll be installed by Doom
  when started for the first time

### Fixed

- Now core plugins will be installed at first start

## [2.1.4] - 2021-05-03

### Fixed

- TreeSitter syntax highlighting and indentation

## [2.1.3] - 2021-05-03

### Deleted

- Unused code in packer setup

### Fixed

- Some bugs in packer setup

## [2.1.2] - 2021-05-02

### Deleted

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

[unreleased]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.1.1...develop
[3.1.1]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.13...v3.1.0
[3.0.13]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.12...v3.0.13
[3.0.12]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.11...v3.0.12
[3.0.11]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.10...v3.0.11
[3.0.10]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.9...v3.0.10
[3.0.9]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.8...v3.0.9
[3.0.8]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.7...v3.0.8
[3.0.7]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.6...v3.0.7
[3.0.6]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.5...v3.0.6
[3.0.5]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.4...v3.0.5
[3.0.4]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.3...v3.0.4
[3.0.3]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.2...v3.0.3
[3.0.2]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/NTBBloodbath/doom-nvim/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.6...v3.0.0
[2.3.6]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.5...v2.3.6
[2.3.5]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.4...v2.3.5
[2.3.4]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.3...v2.3.4
[2.3.3]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.2...v2.3.3
[2.3.2]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.1...v2.3.2
[2.3.1]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.3.0...v2.3.1
[2.3.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.5...v2.2.0
[2.1.5]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.4...v2.1.5
[2.1.4]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.3...v2.1.4
[2.1.3]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.2...v2.1.3
[2.1.2]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.1.0...v2.1.2
[2.1.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/NTBBloodbath/doom-nvim/compare/v0.2.0...v0.3.0
[1.0.0]: https://github.com/NTBBloodbath/doom-nvim/releases/tag/v1.0.0
