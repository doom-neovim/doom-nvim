# Doom Nvim Modules

# Table of Contents
- [Introduction](#introduction)
- [Tweaking Doom Nvim Modules](#tweaking-doom-nvim-modules)
  - [List of modules](#list-of-modules)
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

- Essentials
  - [x] Enabled by default
  - [ ] Can be disabled
  - Plugins inside
    - [ ] packer.nvim      (Plugins manager)
    - [ ] vimpeccable      (Helpers for Lua configs)
    - [ ] vim-polyglot     (Support for languages)
- UI
  - [x] Enabled by default
  - [ ] Can be disabled
  - Plugins inside
    - [ ] dashboard-nvim   (Start screen)
    - [ ] colorschemes     (obviously, colorschemes)
    - [x] nvim-tree        (File tree)
      - Use `tree` to disable it
    - [x] galaxyline.nvim  (Statusline)
      - Use `statusline` to disable it
    - [x] barbar.nvim      (Tabline)
      - Use `tabline` to disable it
    - [x] focus.nvim       (better splits)
      - Use `focus` to disable it
    - [x] nvim-toggleterm  (better terminal)
      - Use `terminal` to disable it
    - [x] vista.vim        (viewer for LSP symbols and tags)
      - Use `vista` to disable it
    - [x] minimap.vim      (Minimap)
      - Use `minimap` to disable it
      - **Depends on** [wfxr/code-minimap](htps://github.com/wfxr/code-minimap) **to work!**
    - [ ] vim-leader-guide (Menu like Emacs's guide-key)
    - [x] goyo.vim         (Distraction free environment)
      - Use `goyo` to disable it
- Fuzzy Search
  - [x] Enabled by default
  - [x] Can be disabled
    - Use `fuzzy` to disable the entire module
  - Plugins inside
    - [x] telescope.nvim   (Fuzzy search & more)
      - Use `telescope` to disable it
      - **NOTE:** dashboard-nvim depends on telescope to do some things, like shortcuts!
- Git
  - [ ] Enabled by default
  - [x] Can be disabled
    - Use `git` to disable the entire module
  - Plugins inside
    - [x] vim-signify      (Show a diff using Vim its sign column)
      - Use `signify` to disable it
    - [x] lazygit          (Call lazygit from within Neovim)
      - Use `lazygit` to disable it
      - **Depends on** [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit) **to work!**
- LSP
  - [ ] Enabled by default
  - [x] Can be disabled
    - Use `lsp` to disable the entire module
  - Plugins inside
    - [x] nvim-lspconfig   (Configurations for the Nvim LSP client)
      - Use `lspconfig` to disable it
      - **NOTE:** do not disable it if you are going to use LSP!
    - [x] nvim-compe       (Auto completion plugin for nvim)
      - Use `compe` to disable it
- Files
  - [x] Enabled by default
  - [x] Can be disabled
    - Use `files` to disable the entire module
  - Plugins inside
    - [x] suda.vim         (Write/Read files without having to use `sudo nvim`, still requires user password!)
      - Use `suda` to disable it
    - [x] neoformat        (File formatting)
      - Use `neoformat` to disable it
    - [x] nvim-autopairs   (Autopairs)
      - Use `autopairs` to disable it
    - [x] indent-blankline (Indent Lines Guide)
      - Use `indentlines` to disable it
    - [x] editorconfig     (EditorConfig support)
      - Use `editorconfig` to disable it
    - [x] treesitter       (Better syntax highlight & more)
      - Use `treesitter` to disable it
    - [x] kommentary       (Comments plugin)
      - Use `kommentary` to disable it
- Web
  - [ ] Enabled by default
  - [x] Can be disabled
    - Use `web` to disable the entire module
  - Plugins inside
    - [x] nvim-colorizer   (Fastest colorizer without external dependencies)
      - Use `colorizer` to disable it
    - [x] vim-dot-http     (Rest HTTP Client)
      - Use `restclient` to disable it
      - **Depends on** [bayne/dot-http](https://github/bayne/dot-http) **to work!**
    - [x] emmet-vim        (Emmet plugin for Vim)
      - Use `emmet` to disable it

## Enabling modules

To enable a module, you can use the `g:doom_disabled_modules` variable on your
`doomrc`.

```vim
" To enable all modules except web, just put only 'web' in the disabled modules
" array and then, reboot Neovim and do :PackerSync
" 
" @default = ['git', 'lsp', 'web']
let g:doom_disabled_modules = ['web']
```

### Enabling module plugins

All the module plugins will be enabled by default unless the entire module is disabled.

> If you want to use custom plugins, please refer to
> [Installing plugins](./getting_started.md#installing-plugins).

## Disabling modules

To disable a module, you can use the `g:doom_disabled_modules` variable
on your `doomrc`.

```vim
" To disable only the web module, just put only 'web' in the disabled modules
" array and then, reboot Neovim and do :PackerSync
" 
" @default = ['git', 'lsp', 'web']
let g:doom_disabled_modules = ['web']
```

### Disabling module plugins

To disable a module plugin, you can use the `g:doom_disabled_plugins` variable
on your `doomrc`.

```vim
" @default = []
let g:doom_disabled_plugins = ['emmet']
```
