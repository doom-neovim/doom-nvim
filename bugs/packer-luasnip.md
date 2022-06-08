

1. I run `:PackerStatus`
2. Press `<CR>` with cursor on `LuaSnip`
3. Nothing happens. If a plugin is listed above alphabetically, then this plugin expands to show info instead.
4. This only happens to LuaSnip it seems.

I have checked that LuaSnip installs as it should and seems to be working. However, I am having trouble getting it to work with cmp but I am assuming that is unrelated to this issue.


### packer.log

I cannot see any messages that pertain to this issue. All are solved to my understanding.

<details>

```
[WARN  Sat May 14 06:05:55 2022 7.8875734006333e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "nvim-lspconfig" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.88757340135e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "galaxyline.nvim" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734021167e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "bufferline.nvim" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734029667e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "neogen" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734037554e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "DAPInstall.nvim" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734046542e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "nvim-lsp-installer" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734053596e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "nvim-autopairs" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734060071e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "Comment.nvim" is used twice! (line 119)
[WARN  Sat May 14 06:05:55 2022 7.8875734067363e+14] ...e/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua:204: Plugin "lua-dev.nvim" is used twice! (line 119)
[ERROR Sun May 15 03:38:55 2022 8.6634055388179e+14] .../site/pack/packer/start/packer.nvim/lua/packer/async.lua:20: Error in coroutine: ...ite/pack/packer/start/packer.nvim/lua/packer/compile.lua:592: Dependency telescope.nvim for { "refactoring.nvim", "telescope-repo.nvim", "telescope-github.nvim", "telescope-packer.nvim", "neorg-telescope", "telescope-z.nvim", "telescope-tele-tabby.nvim" } not found
[ERROR Sun May 29 07:40:41 2022 2.0904843260134e+15] .../site/pack/packer/start/packer.nvim/lua/packer/async.lua:20: Error in coroutine: ...ite/pack/packer/start/packer.nvim/lua/packer/compile.lua:592: Dependency LuaSnip for { "nvim-cmp" } not found
```

</details>

### nvim version

```
NVIM v0.7.0
Build type: Release
LuaJIT 2.1.0-beta3
Compiled by brew@BigSur

Features: +acl +iconv +tui
See ":help feature-compile"

   system vimrc file: "$VIM/sysinit.vim"
  fall-back for $VIM: "/usr/local/Cellar/neovim/0.7.0/share/nvim"
```

### os

macos on macbook air

### packer version

using packer commit: 4dedd3b08f8c6e3f84afbce0c23b66320cd2a8f2
