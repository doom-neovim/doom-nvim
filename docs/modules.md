# Doom Nvim Modules

# Table of Contents

- [Introduction](#introduction)
- [Tweaking Doom Nvim Modules](#tweaking-doom-nvim-modules)
  - [List of modules](#list-of-modules)
    - [Essentials](#essentials)
    - [UI](#ui)
    - [Fuzzy](#fuzzy)
    - [Git](#git)
    - [LSP](#lsp)
    - [Files](#files)
    - [Web](#web)
  - [Managing modules](#managing-modules)
    - [Enabling modules](#enabling-modules)
    - [Enabling module plugins](#enabling-module-plugins)
    - [Disabling modules](#disabling-modules)
    - [Disabling module plugins](#disabling-module-plugins)

# Introduction

Doom Nvim consists of around 7 modules and growing. A Doom Nvim Module is a bundle of plugins,
configuration and commands, organized into a unit that can be toggled easily.

# Tweaking Doom Nvim Modules

You can easily tweak Doom Nvim Modules by tweaking your doomrc
(found in `$HOME/.config/doom-nvim`).

## List of modules

First of all, we must know which modules we can enable and disable,
including their plugins individually.

### Essentials

- [x] Enabled by default
- [ ] Can be disabled
- Plugins inside
  - [ ] [packer.nvim] - A use-package inspired plugin manager for Neovim.
  - [ ] [vimpeccable] - Helpers for Lua configs.
  - [x] [treesitter] - Nvim Treesitter configurations and abstraction layer.
    - Use `treesitter` to disable it

### UI

- [x] Enabled by default
- [ ] Can be disabled
- Plugins inside
  - [ ] [dashboard-nvim] - Vim dashboard.
  - [ ] colorschemes - Obviously, colorschemes.
  - [x] [nvim-tree.lua] - A file explorer tree for neovim written in lua.
    - Use `tree` to disable it
  - [x] [galaxyline.nvim] - galaxyline is a light-weight and Super Fast statusline plugin.
    - Use `statusline` to disable it
  - [x] [barbar.nvim] - Tabs, as understood by any other editor.
    - Use `tabline` to disable it
  - [x] [nvim-toggleterm.lua] - A neovim plugin to persist and toggle multiple terminals during an editing session
    - Use `terminal` to disable it
  - [x] [symbols-outline.nvim] - A tree like view for symbols in Neovim using the Language Server Protocol.
    - Use `tagbar` to disable it
  - [x] [minimap.vim] - Blazing fast minimap / scrollbar for vim, powered by code-minimap written in Rust.
    - Use `minimap` to disable it
    - **Depends on** [wfxr/code-minimap](htps://github.com/wfxr/code-minimap) **to work!**
  - [ ] [which-key.nvim] - WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
  - [x] [TrueZen.nvim] - Clean and elegant distraction-free writing for NeoVim.
    - Use `zen` to disable it

### Fuzzy

- [x] Enabled by default
- [ ] Can be disabled
- Plugins inside
  - [ ] [telescope.nvim] - Find, Filter, Preview, Pick. All lua, all the time.

### Git

- [ ] Enabled by default
- [x] Can be disabled
  - Use `git` to disable the entire module
- Plugins inside
  - [x] [gitsigns.nvim] - Git signs written in pure lua
    - Use `gitsigns` to disable it
  - [x] [lazygit.nvim] - Plugin for calling lazygit from within neovim.
    - Use `lazygit` to disable it
    - **Depends on** [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit) **to work!**

### LSP

- [ ] Enabled by default
- [x] Can be disabled
  - Use `lsp` to disable the entire module
- Plugins inside
  - [x] [nvim-lspconfig] - Quickstart configurations for the Nvim LSP client
    - Use `lspconfig` to disable it
    - **NOTE:** do not disable it if you are going to use LSP!
  - [x] [nvim-compe] - Auto completion plugin for nvim that written in Lua.
    - Use `compe` to disable it

### Files

- [x] Enabled by default
- [x] Can be disabled
  - Use `files` to disable the entire module
- Plugins inside
  - [x] [suda.vim] - suda is a plugin to read or write files with sudo command.
    - Use `suda` to disable it
  - [x] [format.nvim] - Neovim lua plugin to format the current buffer with external executables.
    - Use `formatter` to disable it
  - [x] [pears.nvim] - Auto pair plugin for neovim
    - Use `autopairs` to disable it
  - [x] [indentLine] - A vim plugin to display the indention levels with thin vertical lines
    - Use `indentlines` to disable it
  - [x] [editorconfig-vim] - EditorConfig support
    - Use `editorconfig` to disable it
  - [x] [kommentary] - Neovim commenting plugin, written in lua.
    - Use `kommentary` to disable it

### Web

- [ ] Enabled by default
- [x] Can be disabled
  - Use `web` to disable the entire module
- Plugins inside
  - [x] [nvim-colorizer.lua] - A high-performance color highlighter for Neovim which has no external dependencies written in performant Luajit.
    - Use `colorizer` to disable it
  - [x] [vim-dot-http] - Rest HTTP Client
    - Use `restclient` to disable it
    - **Depends on** [bayne/dot-http](https://github/bayne/dot-http) **to work!**
  - [x] [emmet-vim] - Emmet for Vim
    - Use `emmet` to disable it

## Managing modules

### Enabling modules

To enable a module, you can use the `disabled_modules` field in the `Doom` table
on your `doomrc`.

```lua
-- To enable all modules except web, just put only 'web' in the disabled modules
-- array and then, reboot Neovim and do :PackerSync
--
-- @default = { 'git', 'lsp', 'web' }
disabled_modules = { 'web' }
```

### Enabling module plugins

All the module plugins will be enabled by default unless the entire module is disabled.

> If you want to use custom plugins, please refer to
> [Installing plugins](./getting_started.md#installing-plugins).

### Disabling modules

To disable a module, you can use the `disabled_modules` field in the `Doom` table
on your `doomrc`.

```lua
-- To disable only the web module, just put only 'web' in the disabled modules
-- array and then, reboot Neovim and do :PackerSync
--
-- @default = { 'git', 'lsp', 'web' }
disabled_modules = { 'web' }
```

### Disabling module plugins

To disable a module plugin, you can use the `disabled_plugins` field in the `Doom` table
on your `doomrc`.

```vim
-- @default = {}
disabled_plugins = { 'emmet' }
```

<!-- Essentials -->

[packer.nvim]: https://github.com/wbthomason/packer.nvim
[vimpeccable]: https://github.com/svermeulen/vimpeccable
[treesitter]: https://github.com/nvim-treesitter/nvim-treesitter

<!-- UI -->

[dashboard-nvim]: https://github.com/glepnir/dashboard-nvim
[nvim-tree.lua]: https://github.com/kyazdani42/nvim-tree.lua
[galaxyline.nvim]: https://github.com/glepnir/galaxyline.nvim
[barbar.nvim]: https://github.com/romgrk/barbar.nvim
[focus.nvim]: https://github.com/beauwilliams/focus.nvim
[nvim-toggleterm.lua]: https://github.com/akinsho/nvim-toggleterm.lua
[symbols-outline.nvim]: https://github.com/simrat39/symbols-outline.nvim
[minimap.vim]: https://github.com/wfxr/minimap.vim
[which-key.nvim]: https://github.com/folke/which-key.nvim
[truezen.nvim]: https://github.com/kdav5758/TrueZen.nvim

<!-- Fuzzy -->

[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim

<!-- Git -->

[gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[lazygit.nvim]: https://github.com/kdheepak/lazygit.nvim

<!-- LSP -->

[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-compe]: <!-- Files -->
[suda.vim]: https://github.com/lambdalisue/suda.vim
[format.nvim]: https://github.com/lukas-reineke/format.nvim
[pears.nvim]: https://github.com/steelsojka/pears.nvim
[indentline]: https://github.com/Yggdroot/indentLine
[editorconfig-vim]: https://github.com/editorconfig/editorconfig-vim
[kommentary]: https://github.com/b3nj5m1n/kommentary

<!-- Web -->

[nvim-colorizer.lua]: https://github.com/norcalli/nvim-colorizer.lua
[vim-dot-http]: https://github.com/bayne/vim-dot-http
[emmet-vim]: https://github.com/mattn/emmet-vim
