"================================================
" main.vim - Core of Doom Nvim
" Author: NTBBloodbath
" License: MIT
"================================================

" If the plugin manager is not installed then install it.
if empty(glob('~/.local/share/nvim/site/pack/packer/opt/packer.nvim'))
    silent !git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

    " Sync plugins at startup
    " Clean old/unused/disabled plugins -> Update/install
    augroup doom_sync_plugins
        autocmd!
        autocmd VimEnter * PackerCompile | source $MYVIMRC
        autocmd VimEnter * PackerInstall
    augroup END
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

call doom#end()
