" Define leader key to space
" and call leader mapper
nnoremap <Space> <Nop>
let g:mapleader = " "

"=============================================="

   "========================================"
   "                                        "
   "         Custom Key Mappings            "
   "                                        "
   "  <leader>b  = Buffer Menu              "
   "  <leader>f  = File Menu                "
   "  <leader>g  = Git Menu                 "
   "  <leader>p  = Plugin Menu              "
   "  <leader>r  = Runner Menu              "
   "  <leader>s  = Session Menu             "
   "  <leader>T  = Toggle Menu              "
   "  <leader>w  = Window Menu              "
   "                                        "
   "         TAB = Cycle buffers            "
   "         ESC = Search highlighting off  "
   "          F2 = Toggle Tagbar            "
   "          F3 = Toggle Tree Explorer     "
   "          F4 = Toggle Terminal          "
   "          F5 = Toggle Minimap           "
   "          F6 = Toggle distraction-free  "
   "          F7 = Run dot-http             "
   "                                        "
   "========================================"

"=============================================="

"==========================="
"      LSP Keybindings      "
"==========================="
" If the LSP group is not disabled or the nvim-compe plugin is not disabled
" then set its mappings.
if index(g:doom_disabled_modules, 'lsp') == -1
    " https://github.com/hrsh7th/nvim-compe#mappings
    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <CR>      compe#confirm('<CR>')
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
endif

" tab to cycle buffers too, why not?
nnoremap <silent><Tab> :bnext<CR>
nnoremap <silent><S-Tab> :bprevious<CR>

" esc to turn off search highlighting
nnoremap <silent><esc> :noh<CR>

" F<N> keybindings
if index(g:doom_disabled_plugins, 'vista') == -1
    nnoremap <F2> :Vista!!<CR>
endif
if index(g:doom_disabled_plugins, 'tree') == -1
    nnoremap <F3> :NvimTreeToggle<CR>
endif
if index(g:doom_disabled_plugins, 'terminal') == -1
    nnoremap <F4> :ToggleTerm<CR>
endif
if index(g:doom_disabled_plugins, 'minimap') == -1
    nnoremap <F5> :MinimapToggle<CR>
endif
if index(g:doom_disabled_plugins, 'goyo') == -1
    nnoremap <F6> :Goyo<CR>
endif
if index(g:doom_disabled_modules, 'web') == -1 &&
            \ index(g:doom_disabled_plugins, 'restclient') == -1
    nnoremap <F7> :DotHttp<CR>
endif

"====================="
"    Disable keys     "
"====================="
" disable accidentally pressing ctrl-z and suspending
nnoremap <c-z> <Nop>

" disable ex mode
nnoremap Q <Nop>

" disable recording
nnoremap q <Nop>

" Fast exit from Doom Nvim
nnoremap ZZ :call doom#functions#quit_doom(1,1)<CR>

if index(g:doom_disabled_modules, 'fuzzy') == -1 || index(g:doom_disabled_plugins, 'telescope') == -1
    " Set-up vim_buffer_previewer
    autocmd User TelescopePreviewerLoaded setlocal wrap
endif
