
i need to fix the startup errs below so that vim can start working again in the browser so that you don't need to use it at all.


```vim
[doom] [ERROR 08:02:00] config.lua:90: There was an error loading module 'features.dui'. Traceback:
[doom] ...sson/.config/nvim/lua/doom/modules/features/dui/init.lua:4: module 'telescope.pickers' not found:
[doom] ^Ino field package.preload['telescope.pickers']
[doom] ^Ino file './telescope/pickers.lua'
[doom] ^Ino file '/usr/local/Cellar/luajit-openresty/2.1-20220411/share/luajit-2.1.0-beta3/telescope/pickers.lua'
[doom] ^Ino file '/usr/local/share/lua/5.1/telescope/pickers.lua'
[doom] ^Ino file '/usr/local/share/lua/5.1/telescope/pickers/init.lua'
[doom] ^Ino file '/usr/local/Cellar/luajit-openresty/2.1-20220411/share/lua/5.1/telescope/pickers.lua'
[doom] ^Ino file '/usr/local/Cellar/luajit-openresty/2.1-20220411/share/lua/5.1/telescope/pickers/init.lua'
[doom] ^Ino file './telescope/pickers.so'
[doom] ^Ino file '/usr/local/lib/lua/5.1/telescope/pickers.so'
[doom] ^Ino file '/usr/local/Cellar/luajit-openresty/2.1-20220411/lib/lua/5.1/telescope/pickers.so'
[doom] ^Ino file '/usr/local/lib/lua/5.1/loadall.so'
[doom] ^Ino file './telescope.so'
[doom] ^Ino file '/usr/local/lib/lua/5.1/telescope.so'
[doom] ^Ino file '/usr/local/Cellar/luajit-openresty/2.1-20220411/lib/lua/5.1/telescope.so'
[doom] ^Ino file '/usr/local/lib/lua/5.1/loadall.so'
[doom] stack traceback:
[doom] ^I[C]: in function 'require'
[doom] ^I...sson/.config/nvim/lua/doom/modules/features/dui/init.lua:4: in main chunk
[doom] ^I[C]: at 0x010b6a5713
[doom] ^I[C]: in function 'xpcall'
[doom] ^I...s/hjalmarjakobsson/.config/nvim/lua/doom/core/config.lua:81: in function 'load'
[doom] ^I/Users/hjalmarjakobsson/.config/nvim/lua/doom/core/init.lua:21: in main chunk
[doom] ^I[C]: in function 'require'
[doom] ^I...sson/code/repos/github.com/molleweide/doom-nvim/init.lua:16: in main chunk

packer.nvim: Error running config for nightfox.nvim: ...ack/packer/start/nightfox.nvim/lua/nightfox/override.lua:20: attempt to index local 'opts' (a string value)

packer.nvim: Error running config for gitsigns.nvim: [string "..."]:0: attempt to index field 'git' (a nil value)

[doom] [WARN  08:02:04] [string "..."]:0: doom-treesitter:  clang has poor compatibility compiling treesitter parsers.  We recommend using gcc, see issue #246 for details.  (https://github.com/NTBBloodbath/doom-nvim/issues/246)
```
