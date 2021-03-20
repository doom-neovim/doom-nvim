" Define leader key to space
" and call leader mapper
nnoremap <Space> <Nop>
let g:mapleader = " "

"=============================================

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
"          F4 = Toggle Minimap           "
"          F5 = Toggle distraction-free  "
"          F6 = Run dot-http             "
"                                        "
"========================================"

"=============================================

"==========================="
"      LSP Keybindings      "
"==========================="
" https://github.com/hrsh7th/nvim-compe#mappings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"==========================="
"    Leader Keybindings     "
"==========================="
" - LSP Menu
" Show type definition
nnoremap <leader>lD <cmd>lua vim.lsp.buf.type_definition()<CR>
" Show line diagnostics
nnoremap <leader>le <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
" Diagnostics into location list
nnoremap <leader>lq <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

" - Git Menu
" Open LazyGit
nnoremap <leader>go :LazyGit
" Pull
nnoremap <leader>gP :TermExec git pull<CR>
" Push
nnoremap <leader>gp :TermExec git push<CR>
" Status
nnoremap <leader>gs :TermExec git status<CR>

" - Plugins Menu
" Clean disabled or unused plugins
nnoremap <leader>pc :PackerClean<CR>
" Install missing plugins
nnoremap <leader>pi :PackerInstall<CR>
" Performs PackerClean and then PackerUpdate
nnoremap <leader>ps :PackerSync<CR>
" Update your plugins
nnoremap <leader>pu :PackerUpdate<CR>

" - Buffer Menu
" Go to buffer 1
nnoremap <leader>b1 :BufferGoto 1<CR>
" Go to buffer 2
nnoremap <leader>b2 :BufferGoto 2<CR>
" Go to buffer 3
nnoremap <leader>b3 :BufferGoto 3<CR>
" Go to buffer 4
nnoremap <leader>b4 :BufferGoto 4<CR>
" Go to buffer 5
nnoremap <leader>b5 :BufferGoto 5<CR>
" Go to buffer 6
nnoremap <leader>b6 :BufferGoto 6<CR>
" Go to buffer 7
nnoremap <leader>b7 :BufferGoto 7<CR>
" Go to buffer 8
nnoremap <leader>b8 :BufferGoto 8<CR>
" Go to last buffer
nnoremap <leader>b9 :BufferLast<CR>
" Close current buffer
nnoremap <leader>bc :BufferClose<CR>
" Format buffer
nnoremap <leader>bf :Neoformat<CR>
" Next buffer
nnoremap <leader>bn :BufferNext<CR>
" Pick buffer
nnoremap <leader>bP :BufferPick<CR>
" Previous buffer
nnoremap <leader>bp :BufferPrevious<CR>

" - Order buffer menu
" Sort by directory
nnoremap <leader>od :BufferOrderByDirectory<CR>
" Sort by language
nnoremap <leader>ol :BufferOrderByLanguage<CR>
" Re-order buffer to next
nnoremap <leader>on :BufferMoveNext<CR>
" Re-order buffer to previous
nnoremap <leader>op :BufferMovePrevious<CR>

" - File Menu
" Bookmarks
nnoremap <leader>fb :Telescope marks<CR>
" Edit Neovim configuration
nnoremap <leader>fc :e $MYVIMRC<CR>
" Find file
nnoremap <leader>ff :Telescope find_files<CR>
" Find word
nnoremap <leader>fg :Telescope live_grep<CR>
" Help tags
nnoremap <leader>ft :Telescope help_tags<CR>
" Write file with sudo permissions (For unwritable files)
nnoremap <leader>fw :SudaWrite<CR>
" Re-open file with sudo permissions (For unreadable files only!)
nnoremap <leader>fr :SudaRead<CR>
" Override existing telescope <leader>fh mapping
autocmd VimEnter * noremap <leader>fh :Telescope oldfiles<CR>
" Recently opened files
nnoremap <leader>fh :Telescope oldfiles<CR>
" Create a new unnamed buffer
nnoremap <leader>fn :new<CR>

" - Window Menu
" Close all other windows
nnoremap <leader>wC :only<CR>
" Close current window
nnoremap <leader>wc :close<CR>
" Split horizontally
nnoremap <leader>wh :split<CR>
" Split vertically
nnoremap <leader>wv :vsplit<CR>

" - Runner Menu
" Run dot-http on the line that the cursor is currently on
nnoremap <leader>rh :DotHttp<CR>

" - Session Menu
" Save session
nmap <leader>ss :<C-u>SessionSave<CR>
" Load session
nmap <leader>sl :<C-u>SessionLoad<CR>

" ToggleTerm custom function to avoid having
" line numbers inside the terminal buffer
" because that is not from God.
function ToggleTerm()
    execute "ToggleTerm"
    set nonumber norelativenumber
endfunction
" Toggle Menu
" Change colorscheme
nnoremap <leader>tc   :DashboardChangeColorscheme<CR>
" Toggle Tree Explorer
nnoremap <leader>te   :NvimTreeToggle<CR>
" Toggle Minimap
nnoremap <leader>tm   :MinimapToggle<CR>
" Toggle Line Numbers
nnoremap <leader>tn   :set number! relativenumber!<CR>
" Open start screen
nnoremap <leader>ts   :Dashboard<CR>
" Toggle Tags view
nnoremap <leader>tT   :Vista!!<CR>
" Open a new terminal
nnoremap <leader>tt   :call ToggleTerm()<CR>

" tab to cycle buffers too, why not?
nnoremap <silent><Tab> :bnext<CR>
nnoremap <silent><S-Tab> :bprevious<CR>

" esc to turn off search highlighting
nnoremap <silent><esc> :noh<CR>

" F<N> keybindings
nnoremap <F2> :Vista!!<CR>
nnoremap <F3> :NvimTreeToggle<CR>
nnoremap <F4> :MinimapToggle<CR>
nnoremap <F5> :Goyo<CR>")
nnoremap <F6> :DotHttp<CR>

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

" Set-up vim_buffer_ previewer
autocmd User TelescopePreviewerLoaded setlocal wrap
