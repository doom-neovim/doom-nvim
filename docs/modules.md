# Doom Nvim Modules

## Introduction

Doom Nvim consists of around 5 modules with ~40 plugins and growing.
A Doom Nvim module is a bundle of plugins, configurations and commands,
organized into a unit that can be toggled easily.

> **NOTE**: Doom Nvim uses [packer.nvim] as its plugins manager.

## Tweaking Doom Nvim Modules

You can easily tweak Doom Nvim Modules by tweaking your `doom_modules.lua` file
(found in `~/.config/doom-nvim`).

## List of modules

First of all, we must know which modules are there and their plugins.

> **NOTE:** all plugins can be disabled, including the UI ones.

### Essentials

This ones are implicit plugins so the end user cannot disable them. But why?

That is because these plugins are the core of Doom so in fact, things can break
without them. These plugins are the following:

- [packer.nvim]
  - A use-package inspired plugin manager for Neovim.
- [treesitter]
  - An incremental parsing system for programming tools.

### UI

- [dashboard]
  - Vim dashboard (start screen).
- [doom-themes]
  - Additional doom emacs' colorschemes.
- [indentlines]
  - Show indent lines.
- [statusline]
  - Neovim statusline.
- [tabline]
  - Tabline, shows your buffers list at top.
- [which-key]
  - Keybindings popup like Emacs' guide-key.
- [zen]
  - Distraction free environment.

### Doom

- [compiler] (built-in)
  - Compile _and run_ your projects with only a few keystrokes.
- [neorg]
  - Life Organization Tool.
- [runner] (built-in)
  - A code runner for your interpreted code.

### Editor

- [autopairs]
  - Autopairs.
- [auto-session]
  - A small automated session manager for Neovim.
- [editorconfig]
  - EditorConfig support for Neovim, let other argue about tabs vs spaces.
- [explorer]
  - Tree explorer.
- [formatter]
  - File formatting.
- [gitsigns]
  - Git signs.
- [kommentary]
  - Comments plugin.
- [lsp]
  - Language Server Protocols ([compe] + [lspinstall]).
- [minimap]
  - Code minimap, requires [wfxr/code-minimap](https://github.com/wfxr/code-minimap).
- snippets
  - Code snippets ([LuaSnip] + [friendly-snippets]).
- [symbols]
  - LSP symbols and tags.
- [telescope]
  - Highly extendable fuzzy finder over lists.
- [terminal]
  - Terminal for Neovim.

### Langs

The languages module entries has some flags that improves their experience and
makes your life easier.

The currently available flags are the following:

- `+lsp` - enables and installs the Language Server Protocol for the language.
  e.g. `rust +lsp` will automatically install `rust-analyzer`.
- `+debug` - enables and installs the Debug Adapter Protocol client for the
  language. e.g. `python +debug` will automatically install `debugpy`.

> **NOTE**: when the language entry is not commented, doom-nvim will automatically
> install the TreeSitter parser for that language too.

#### Web development

- **css**
  - CSS support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **html**
  - HTML support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **javascript**
  - JavaScript support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes, by using TSServer.
  - DAP client: yes.
- **PHP**
  - PHP support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **typescript**
  - TypeScript support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes (via javascript).
- **Svelte**
  - Svelte support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes (via javascript).
- **Vue**
  - Vue support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes (via javascript).

#### Scripting

- **bash**
  - BASH support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **clojure**
  - Clojure support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **elixir**
  - Elixir support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **lua**
  - Lua support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no (it has but isn't supported by Doom _yet_, requires extra setup).
- **powershell**
  - PowerShell support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **python**
  - Python support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes.
- **ruby**
  - Ruby support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes.

#### Compiled

- **cpp**
  - CPP support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes (not supported _yet_ by Doom for automatic installation).
- **c_sharp (C#)**
  - C# support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **go**
  - Golang support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes.
- **haskell**
  - Haskell support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **java**
  - Java support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **kotlin**
  - Kotlin support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: no.
- **rust**
  - Rust support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
  - DAP client: yes (not supported _yet_ by Doom for automatic installation).

#### Configs & DevOps

- **json**/**json5**
  - JSON support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **yaml**
  - YAML support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **toml**
  - TOML support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: no.
- **xml**
  - XML support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: no.
- **dockerfile**
  - Docker support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.

> **NOTE**: this group requires the `lsp` installed for the `+lsp` flags.

### Utilities

- [lazygit]
  - LazyGit integration for neovim, requires LazyGit.
- [neogit]
  - Magit for Neovim.
- [range-highlight]
  - Highlights ranges you have entered in commandline
- [suda]
  - Write and read files without sudo permissions.

### Web

- [colorizer]
  - Fastest colorizer for Neovim.
- [restclient]
  - A fast Neovim http client.

## Managing modules

Since version 3.0.0 managing the modules plugins is really easy because you
don't need to learn nothing anymore. Just comment the plugins that you don't
want to use and uncomment the ones that you are going to use!

So by example, if you want to disable the tree explorer you can simply comment it.

```lua
-- Before, the plugin is enabled
'explorer',    -- Tree explorer

-- After, the plugin is disabled
-- 'explorer', -- Tree explorer
```

After doing the changes, just restart Neovim and Doom Nvim will handle the plugins
changes for you!

<!-- links to plugins -->

[packer.nvim]: https://github.com/wbthomason/packer.nvim
[treesitter]: https://github.com/nvim-treesitter/nvim-treesitter

[auto-session]: https://github.com/rmagatti/auto-session
[dashboard]: https://github.com/glepnir/dashboard-nvim
[explorer]: https://github.com/kyazdani42/nvim-tree.lua
[statusline]: https://github.com/glepnir/galaxyline.nvim
[tabline]: https://github.com/akinsho/nvim-bufferline.lua
[terminal]: https://github.com/akinsho/nvim-toggleterm.lua
[symbols]: https://github.com/simrat39/symbols-outline.nvim
[minimap]: https://github.com/wfxr/minimap.vim
[which-key]: https://github.com/folke/which-key.nvim
[zen]: https://github.com/kdav5758/TrueZen.nvim
[telescope]: https://github.com/nvim-telescope/telescope.nvim
[doom-themes]: https://github.com/GustavoPrietoP/doom-themes.nvim

[gitsigns]: https://github.com/lewis6991/gitsigns.nvim
[lazygit]: https://github.com/kdheepak/lazygit.nvim
[neogit]: https://github.com/TimUntersberger/neogit
[neorg]: https://github.com/vhyrro/neorg

[lsp]: https://github.com/neovim/nvim-lspconfig
[compe]: https://github.com/hrsh7th/nvim-compe
[lsp-installer]: https://github.com/williamboman/nvim-lsp-installer
[LuaSnip]: https://github.com/L3MON4D3/LuaSnip
[friendly-snippets]: https://github.com/rafamadriz/friendly-snippets

[suda]: https://github.com/lambdalisue/suda.vim
[formatter]: https://github.com/lukas-reineke/format.nvim
[autopairs]: https://github.com/windwp/nvim-autopairs
[indentlines]: https://github.com/lukas-reineke/indent-blankline.nvim
[editorconfig]: https://github.com/editorconfig/editorconfig-vim
[kommentary]: https://github.com/b3nj5m1n/kommentary

[restclient]: https://github.com/NTBBloodbath/rest.nvim
[colorizer]: https://github.com/norcalli/nvim-colorizer.lua
[range-highlight]: https://github.com/winston0410/range-highlight.nvim

[runner]: ../lua/doom/modules/built-in/runner/README.md
[compiler]: ../lua/doom/modules/built-in/compiler/README.md
