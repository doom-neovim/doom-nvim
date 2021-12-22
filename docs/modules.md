# Doom Nvim Modules

## Introduction

Doom Nvim consists of around 40 plugins and growing.
A Doom Nvim module is a bundle of packages, configurations, autocommands and
binds, organized into a unit that can be toggled easily.

> **NOTE**: Doom Nvim uses [packer.nvim] as its plugins manager.

## Toggling Doom Nvim Modules

You can easily toggle Doom Nvim Modules by tweaking your `doom-nvim/modules.lua` file
(found in `~/.config/doom-nvim`). Return from this file a flat list of modules
you want. The `core` module is required and need not be listed.

## List of modules

First of all, we must know which modules are there and their plugins.

> **NOTE:** all modules can be disabled, except `core`. Also, anything can be
overriden in `doom-nvim/config.lua`, from packer specs to vim options.

### Essentials in core

This is the one module you cannot disable. But why?

That is because these plugins are the core of Doom, why would you want a
framework without these basic functionalies? These plugins are the following:

- [packer.nvim]
  - A use-package inspired plugin manager for Neovim.
- [nvim-treesitter and companions]
  - An incremental parsing system for programming tools.
- [nest.nvim]
  - A better way to set keybindings and create nvim-mapper structures.
- [nvim-mapper]
  - A cheatsheet generator for your binds.

### UI modules

- [colorizer]
  - Fastest colorizer for Neovim.
- [dashboard]
  - Vim dashboard (start screen).
- [doom_themes]
  - Additional doom emacs' colorschemes.
- [indentlines]
  - Show indent lines.
- [range_highlight]
  - Highlights ranges you have entered in commandline
- [statusline]
  - Neovim statusline.
- [tabline]
  - Tabline, shows your buffers list at top.
- [whichkey]
  - Keybindings popup like Emacs' whichj-key.
- [zen]
  - Distraction free environment.


### Lang modules

- [neorg]
  - Life Organization Tool.

### Editor modules

- [autopairs]
  - Autopairs.
- [auto_session]
  - A small automated session manager for Neovim.
- [editorconfig]
  - EditorConfig support for Neovim, let other people argue about tabs vs spaces.
- [explorer]
  - Tree explorer.
- [formatter]
  - File formatting.
- [gitsigns]
  - Git signs.
- [kommentary]
  - Comments plugin.
- [lsp]
  - Language Server Protocols ([cmp] + [lspconfig]).
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

### Utilities modules

- [lazygit]
  - LazyGit integration for neovim, requires LazyGit.
- [neogit]
  - Magit for Neovim.
- [suda]
  - Write and read files without sudo permissions.
- [superman]
  - Manage man files.
- [restclient]
  - A fast Neovim http client.

## Managing modules

Configurations go in `doom-nvim/config.lua`. In this file, a `doom` global variable
is injected with defaults suh that you can override or insert to your liking.

Common patterns:

> **NOTE**: prefer setting the leaf keys, setting an entire table will override
> everything.

- Install package/override existing if name is already there:
  ```lua
  -- Use fork.
  doom.packages[name][1] = "myfork/name.nvim"
  -- Add config to be run after module config.
  doom.packages[name].config = function()
    require("name.whatever").do_something({
      -- ..
    })
  end
  ```
- Add binds to your liking:
  ```lua
  table.insert(doom.binds, { 
    { "RnT", "<cmd>RipAndTear<CR>", name = "Until it is done" },
  })
  ```
- Add autocmds (`doom_` will be prefixed to the name):
  ```lua
  doom.autocmds[augroup_name] = { 
    { "BufReadPre", "*.lua", --[[once and nested go here if needed]] "setlocal sw=2" },
  }
  ```

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
[cmp]: https://github.com/hrsh7th/nvim-cmp
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
