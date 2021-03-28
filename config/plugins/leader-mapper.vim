" Define prefix dictionary
let g:lmap = {}

" LSP Menu
if index(g:doom_disabled_modules, 'lsp') == -1 && index(g:doom_disabled_plugins, 'compe') == -1
    let g:lmap.l = {'name': 'LSP Menu'}
    " Show type definition
    nnoremap <leader>lD <cmd>lua vim.lsp.buf.type_definition()<CR>
    let g:lmap.l.D = 'Show type definition'
    " Show line diagnostics
    nnoremap <leader>le <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
    let g:lmap.l.e = 'Show line diagnostics'
    " Diagnostics into location list
    nnoremap <leader>lq <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
    let g:lmap.l.q = 'Diagnostics into location list'
endif

" Git Menu
if index(g:doom_disabled_modules, 'git') == -1 && index(g:doom_disabled_plugins, 'lazygit') == -1 ||
            \ index(g:doom_disabled_modules, 'git') == -1 && index(g:doom_disabled_plugins, 'toggleterm') == -1 ||
            \ index(g:doom_disabled_modules, 'git') == -1 && index(g:doom_disabled_plugins, 'gitsigns') == -1
    let g:lmap.g = {'name': 'Git Menu'}
    if index(g:doom_disabled_plugins, 'lazygit') == -1
        " Open LazyGit
        nnoremap <leader>go :LazyGit<CR>
        let g:lmap.g.o = 'Open LazyGit'
    endif
    if index(g:doom_disabled_plugins, 'toggleterm') == -1
        " Pull
        nnoremap <leader>gP :TermExec cmd='git pull'<CR>
        let g:lmap.g.P = 'Pull'
        " Push
        nnoremap <leader>gp :TermExec cmd='git push'<CR>
        let g:lmap.g.p = 'Push'
        " Status
        nnoremap <leader>gs :TermExec cmd='git status'<CR>
        let g:lmap.g.s = 'Status'
    endif
    if index(g:doom_disabled_plugins, 'gitsigns') == -1
        " Stage hunk
        let g:lmap.g.S = 'Stage hunk'
        " Undo stage hunk
        let g:lmap.g.u = 'Undo stage hunk'
        " Reset hunk
        let g:lmap.g.r = 'Reset hunk'
        " Reset buffer
        let g:lmap.g.R = 'Reset buffer'
        " Preview hunk
        let g:lmap.g.h = 'Preview hunk'
        " Blame line
        let g:lmap.g.b = 'Blame line'
    endif
endif

" Plugin Menu
let g:lmap.p = {'name': 'Plugin Menu'}
" Clean disabled or unused plugins
nnoremap <leader>pc :PackerClean<CR>
let g:lmap.p.c = 'Clean disabled or unused plugins'
" Install missing plugins
nnoremap <leader>pi :PackerInstall<CR>
let g:lmap.p.i = 'Install missing plugins'
" Performs PackerClean and then PackerUpdate
nnoremap <leader>ps :PackerSync<CR>
let g:lmap.p.s = 'Performs PackerClean and then PackerUpdate'
" Update your plugins
nnoremap <leader>pu :PackerUpdate<CR>
let g:lmap.p.u = 'Update your plugins'

" Buffer Menu
let g:lmap.b = {'name': 'Buffer Menu'}
" Go to buffer 1
nnoremap <leader>b1 :BufferGoto 1<CR>
let g:lmap.b.1 = 'Buffer 1'
" Go to buffer 2
nnoremap <leader>b2 :BufferGoto 2<CR>
let g:lmap.b.2 = 'Buffer 2'
" Go to buffer 3
nnoremap <leader>b3 :BufferGoto 3<CR>
let g:lmap.b.3 = 'Buffer 3'
" Go to buffer 4
nnoremap <leader>b4 :BufferGoto 4<CR>
let g:lmap.b.4 = 'Buffer 4'
" Go to buffer 5
nnoremap <leader>b5 :BufferGoto 5<CR>
let g:lmap.b.5 = 'Buffer 5'
" Go to buffer 6
nnoremap <leader>b6 :BufferGoto 6<CR>
let g:lmap.b.6 = 'Buffer 6'
" Go to buffer 7
nnoremap <leader>b7 :BufferGoto 7<CR>
let g:lmap.b.7 = 'Buffer 7'
" Go to buffer 8
nnoremap <leader>b8 :BufferGoto 8<CR>
let g:lmap.b.8 = 'Buffer 8'
" Go to last buffer
nnoremap <leader>b9 :BufferLast<CR>
let g:lmap.b.9 = 'Last buffer'
" Close current buffer
nnoremap <leader>bc :BufferClose<CR>
let g:lmap.b.c = 'Close buffer'
" Format buffer
nnoremap <leader>bf :Neoformat<CR>
let g:lmap.b.f = 'Format buffer'
" Next buffer
nnoremap <leader>bn :BufferNext<CR>
let g:lmap.b.n = 'Next buffer'
" Pick buffer
nnoremap <leader>bP :BufferPick<CR>
let g:lmap.b.P = 'Pick buffer'
" Previous buffer
nnoremap <leader>bp :BufferPrevious<CR>
let g:lmap.b.p = 'Previous buffer'

" Order Buffer Menu
let g:lmap.o = {'name': 'Order Menu'}
" Sort by directory
nnoremap <leader>od :BufferOrderByDirectory<CR>
let g:lmap.o.d = 'Sort by directory'
" Sort by language
nnoremap <leader>ol :BufferOrderByLanguage<CR>
let g:lmap.o.l = 'Sort by language'
" Re-order buffer to next
nnoremap <leader>on :BufferMoveNext<CR>
let g:lmap.o.n = 'Re-order buffer to next'
" Re-order buffer to previous
nnoremap <leader>op :BufferMovePrevious<CR>
let g:lmap.o.p = 'Re-order buffer to previous'

" File Menu
let g:lmap.f = {'name': 'File Menu'}
" Edit Neovim configuration
nnoremap <leader>fc :e $MYVIMRC<CR>
let g:lmap.f.c = 'Edit Neovim configuration'
" Create a new unnamed buffer
nnoremap <leader>fn :new<CR>
let g:lmap.f.n = 'Create a new unnamed buffer'
if index(g:doom_disabled_plugins, 'telescope') == -1
    " Bookmarks
    nnoremap <leader>fb :Telescope marks<CR>
    let g:lmap.f.b = 'Bookmarks'
    " Find file
    nnoremap <leader>ff :Telescope find_files<CR>
    let g:lmap.f.f = 'Find file'
    " Find word
    nnoremap <leader>fg :Telescope live_grep<CR>
    let g:lmap.f.g = 'Find word'
    " Help tags
    nnoremap <leader>ft :Telescope help_tags<CR>
    let g:lmap.f.t = 'Help Tags'
    " Override existing telescope <leader>fh mapping
    autocmd VimEnter * noremap <leader>fh :Telescope oldfiles<CR>
    " Recently opened files
    nnoremap <leader>fh :Telescope oldfiles<CR>
    let g:lmap.f.h = 'Recently opened files'
endif
if index(g:doom_disabled_plugins, 'suda') == -1
    " Write file with sudo permissions (For unwritable files)
    nnoremap <leader>fw :SudaWrite<CR>
    let g:lmap.f.w = 'Write file with sudo permissions (For unwritable files)'
    " Re-open file with sudo permissions (For unreadable files only!)
    nnoremap <leader>fr :SudaRead<CR>
    let g:lmap.f.r = 'Re-open file with sudo permissions (For unreadable files only!)'
endif

" Window Menu
let g:lmap.w = {'name': 'Window Menu'}
" Close all other windows
nnoremap <leader>wC :only<CR>
let g:lmap.w.C = 'Close all other windows'
" Close current window
nnoremap <leader>wc :close<CR>
let g:lmap.w.c = 'Close current window'
" Split horizontally
nnoremap <leader>wh :split<CR>
let g:lmap.w.h = 'Split horizontally'
" Split vertically
nnoremap <leader>wv :vsplit<CR>
let g:lmap.w.v = 'Split vertically'

" Runner Menu
if index(g:doom_disabled_modules, 'web') == -1
    let g:lmap.r = {'name': 'Runner Menu'}
    if  index(g:doom_disabled_plugins, 'dot-http') == -1
        " Run dot-http on the line that the cursor is currently on
        nnoremap <leader>rh :DotHttp<CR>
        let g:lmap.r.h = 'Run dot-http on the line that the cursor is currently on'
    endif
endif

" Session Menu
let g:lmap.s = {'name': 'Session Menu'}
" Save session
nnoremap <leader>ss :<C-u>SessionSave<CR>
let g:lmap.s.s = 'Save session'
" Load session
nnoremap <leader>sl :<C-u>SessionLoad<CR>
let g:lmap.s.l = 'Load session'

" Doom Menu
let g:lmap.d = {'name': 'Doom Menu'}
" Open your Doom Nvim configurations
nnoremap <leader>dc :e ~/.config/doom-nvim/doomrc<CR>
let g:lmap.d.c = 'Edit your Doom Nvim configuration'
" Open Doom Nvim docs
nnoremap <leader>dd :help doom_nvim<CR>
let g:lmap.d.d = 'Open Doom Nvim Documentation'
" Check Doom Nvim Updates and update if available
nnoremap <leader>du :DoomUpdate<CR>
let g:lmap.d.u = 'Check Doom Nvim Updates'

" ToggleNumbers function,
" toggle between relative numbers and absolute numbers
" depending on the value of g:doom_relative_num
function ToggleNumbers()
    if g:doom_relative_num ==# 1
        set number! relativenumber!
    else
        set number!
    endif
endfunction
" Toggle Menu
let g:lmap.t = {'name': 'Toggler Menu'}
" Toggle Line Numbers
nnoremap <leader>tn :call ToggleNumbers()<CR>
let g:lmap.t.n = 'Toggle Line Numbers'
" Open start screen
nnoremap <leader>ts :Dashboard<CR>
let g:lmap.t.s = 'Open start screen'
" Change colorscheme
nnoremap <leader>tc :DashboardChangeColorscheme<CR>
let g:lmap.t.c = 'Change colorscheme'
if index(g:doom_disabled_plugins, 'tree') == -1
    " Toggle Tree Explorer
    nnoremap <leader>te :NvimTreeToggle<CR>
    let g:lmap.t.e = 'Toggle Tree Explorer'
endif
if index(g:doom_disabled_plugins, 'minimap') == -1
    " Toggle Minimap
    nnoremap <leader>tm :MinimapToggle<CR>
    let g:lmap.t.m = 'Toggle Minimap'
endif
if index(g:doom_disabled_plugins, 'vista') == -1
    " Toggle Tags view
    nnoremap <leader>tT :Vista!!<CR>
    let g:lmap.t.T = 'Toggle Tags view'
endif
if index(g:doom_disabled_plugins, 'toggleterm') == -1
    " Open a new terminal
    nnoremap <leader>tt :call doom#functions#toggle_terminal()<CR>
    let g:lmap.t.t = 'Toggle terminal'
endif

" Display menus with a `+` in-front of the description (à la emacs-which-key).
let g:leaderGuide_display_plus_menus = 1
" Register the dictionary
call leaderGuide#register_prefix_descriptions('<Space>', 'g:lmap')
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
