"================================================
" main.vim - Core of Doom Nvim
" Author: NTBBloodbath
" License: MIT
"================================================

" If the plugin manager is not installed then install it.
if empty(glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim'))
    silent !git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

    " Install plugins at startup
    autocmd VimEnter * execute "PackerInstall" | source $MYVIMRC
    " source $MYVIMRC
endif

" Set some configurations on load
if has('vim_starting')
    " Set UTF-8 encoding
    set encoding=utf-8
    " Required to use some colorschemes and improve colors
    set termguicolors
endif

" Start Doom configs and run packer.nvim
call doom#begin()

" /home/user/.doom-nvim/lua/plugins.lua
lua require('plugins')
" Plugins configurations, will be loaded only if the plugin is enabled!
" /home/user/.doom-nvim/lua/configs/*.lua
if doom#functions#checkplugin('nvim-autopairs')
    lua require('configs.autopairs')
endif
if doom#functions#checkplugin('nvim-lspconfig')
    lua require('configs.lsp')
endif
if doom#functions#checkplugin('nvim-colorizer.lua')
    lua require('configs.nvim-colorizer')
endif
if doom#functions#checkplugin('nvim-compe')
    lua require('configs.nvim-compe')
endif
if doom#functions#checkplugin('focus.nvim')
    lua require('configs.nvim-focus')
endif
if doom#functions#checkplugin('telescope.nvim')
    lua require('configs.nvim-telescope')
endif
if doom#functions#checkplugin('nvim-toggleterm.lua')
    lua require('configs.nvim-toggleterm')
endif
if doom#functions#checkplugin('nvim-tree.lua')
    lua require('configs.nvim-tree')
endif
if doom#functions#checkplugin('galaxyline.nvim')
    lua require('configs.statusline')
endif
if doom#functions#checkplugin('nvim-treesitter')
    lua require('configs.tree-sitter')
endif
if doom#functions#checkplugin('gitsigns.nvim')
    lua require('configs.nvim-gitsigns')
endif

call doom#end()
