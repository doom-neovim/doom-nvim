# Doom Nvim Modules

## Introduction

Doom Nvim consists of around 5 modules with ~30 plugins and growing.
A dDoom Nvim module is a bundle of plugins, configurations and commands,
organized into a unit that can be toggled easily.

> **NOTE**: Doom Nvim uses [packer.nvim] as its plugins manager.

## Tweaking Doom Nvim Modules

You can easily tweak Doom Nvim Modules by tweaking your `doomrc.lua` file
(found in `~/.config/doom-nvim`).

## List of modules

First of all, we must know which modules are there and their plugins.

> **NOTE:** all plugins can be disabled, including the UI ones.

### UI

- [dashboard]
  - Vim dashboard (start screen).
- [doom-themes]
  - Additional doom emacs' colorschemes.
- [statusline]
  - Neovim statusline.
- [tabline]
  - Tabline, shows your buffers list at top.
- [zen]
  - Distraction free environment.
- [which-key]
  - Keybindings popup like Emacs' guide-key.
- [indentlines]
  - Show indent lines.

### Doom

- [neorg]
  - Life Organization Tool.

### Editor

- [auto-session]
  - A small automated session manager for Neovim.
- [terminal]
  - Terminal for Neovim.
- [explorer]
  - Tree explorer.
- [symbols]
  - LSP symbols and tags.
- [minimap]
  - Code minimap, requires [wfxr/code-minimap](https://github.com/wfxr/code-minimap).
- [gitsigns]
  - Git signs.
- [telescope]
  - Highly extendable fuzzy finder over lists.
- [restclient]
  - A fast Neovim http client.
- [formatter]
  - File formatting.
- [autopairs]
  - Autopairs.
- [editorconfig]
  - EditorConfig support for Neovim, let other argue about tabs vs spaces.
- [kommentary]
  - Comments plugin.
- [lsp]
  - Language Server Protocols ([compe] + [lspsaga] + [lspinstall]).
- [treesitter]
  - An incremental parsing system for programming tools.
- [snippets]
  - LSP code snippets.

### Langs

- **javascript**
  - JavaScript support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes, by using TSServer.
- **typescript**
  - TypeScript support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **python**
   Python support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **lua**
  - Lua support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **rust**
  - Rust support.
  - TreeSitter based syntax highlighting: yes.
  - LSP: yes.
- **config**
  - Configuration languages support (JSON, YAML, TOML).
  - TreeSitter based syntax highlighting: yes.
  - LSP: not yet.

> **NOTE**: this group requires `treesitter` enabled for getting syntax highlighting
> and `lsp` for the `+lsp` flags.

### Utilities

- [suda]
  - Write and read files without sudo permissions.
- [lazygit]
  - LazyGit integration for neovim, requires LazyGit.
- [neogit]
  - Magit for Neovim.
- [octo]
  - GitHub in Neovim, requires GitHub CLI.
- [colorizer]
  - Fastest colorizer for Neovim.
- [range-highlight]
  - Highlights ranges you have entered in commandline

## Managing modules

Since version 3.0.0 managing the modules plugins is really easy, you don't need
to learn nothing anymore. Just comment the plugins that you don't want to use
and uncomment the ones that you are going to use!

So by example, if you want to disable the tree explorer you can simply comment it.

```lua
-- Before, the plugin is enabled
'explorer', -- Tree explorer

-- After, the plugin is disabled
-- 'explorer', -- Tree explorer
```

After doing the changes, just restart Neovim and Doom Nvim will handle the plugins
changes for you!

<!-- links to plugins -->

[packer.nvim]: https://github.com/wbthomason/packer.nvim
[treesitter]: https://github.com/nvim-treesitter/nvim-treesitter

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

[gitsigns]: https://github.com/lewis6991/gitsigns.nvim
[lazygit]: https://github.com/kdheepak/lazygit.nvim
[octo]: https://github.com/pwntester/octo.nvim
[neogit]: https://github.com/TimUntersberger/neogit
[neorg]: https://github.com/vhyrro/neorg

[lsp]: https://github.com/neovim/nvim-lspconfig
[compe]: https://github.com/hrsh7th/nvim-compe
[lspsaga]: https://github.com/glepnir/lspsaga.nvim
[lspinstall]: https://github.com/kabouzeid/nvim-lspinstall
[snippets]: https://github.com/norcalli/snippets.nvim

[suda]: https://github.com/lambdalisue/suda.vim
[formatter]: https://github.com/lukas-reineke/format.nvim
[autopairs]: https://github.com/windwp/nvim-autopairs
[indentlines]: https://github.com/lukas-reineke/indent-blankline.nvim
[editorconfig]: https://github.com/editorconfig/editorconfig-vim
[kommentary]: https://github.com/b3nj5m1n/kommentary

[restclient]: https://github.com/NTBBloodbath/rest.nvim
[colorizer]: https://github.com/norcalli/nvim-colorizer.lua
[range-highlight]: https://github.com/winston0410/range-highlight.nvim
