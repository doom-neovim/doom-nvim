" Define prefix dictionary
let g:lmap = {}

" LSP Menu
let g:lmap.l = {"name": "LSP Menu"}
let g:lmap.l.D = "Show type definition"
let g:lmap.l.e = "Show line diagnostics"
let g:lmap.l.q = "Diagnostics into location list"

" Git Menu
let g:lmap.g = {"name": "Git Menu"}
let g:lmap.g.o = "Open LazyGit"
let g:lmap.g.P = "Pull"
let g:lmap.g.p = "Push"
let g:lmap.g.s = "Status"

" Plugin Menu
let g:lmap.p = {"name": "Plugin Menu"}
let g:lmap.p.c = "Clean disabled or unused plugins"
let g:lmap.p.i = "Install missing plugins"
let g:lmap.p.s = "Performs PackerClean and then PackerUpdate"
let g:lmap.p.u = "Update your plugins"

" Buffer Menu
let g:lmap.b = {"name": "Buffer Menu"}
let g:lmap.b.1 = "Buffer 1"
let g:lmap.b.2 = "Buffer 2"
let g:lmap.b.3 = "Buffer 3"
let g:lmap.b.4 = "Buffer 4"
let g:lmap.b.5 = "Buffer 5"
let g:lmap.b.6 = "Buffer 6"
let g:lmap.b.7 = "Buffer 7"
let g:lmap.b.8 = "Buffer 8"
let g:lmap.b.9 = "Last buffer"
let g:lmap.b.c = "Close buffer"
let g:lmap.b.f = "Format buffer"
let g:lmap.b.n = "Next buffer"
let g:lmap.b.P = "Pick buffer"
let g:lmap.b.p = "Previous buffer"

" Order Buffer Menu
let g:lmap.o = {"name": "Order Menu"}
let g:lmap.o.d = "Sort by directory"
let g:lmap.o.l = "Sort by language"
let g:lmap.o.n = "Re-order buffer to next"
let g:lmap.o.p = "Re-order buffer to previous"

" File Menu
let g:lmap.f = {"name": "File Menu"}
let g:lmap.f.b = "Bookmarks"
let g:lmap.f.c = "Edit Neovim configuration"
let g:lmap.f.f = "Find file"
let g:lmap.f.g = "Find word"
let g:lmap.f.t = "Help Tags"
let g:lmap.f.w = "Write file with sudo permissions (For unwritable files)"
let g:lmap.f.r = "Re-open file with sudo permissions (For unreadable files only!)"
let g:lmap.f.h = "Recently opened files"
let g:lmap.f.n = "Create a new unnamed buffer"

" Window Menu
let g:lmap.w = {"name": "Window Menu"}
let g:lmap.w.C = "Close all other windows"
let g:lmap.w.c = "Close current window"
let g:lmap.w.h = "Split horizontally"
let g:lmap.w.v = "Split vertically"

" Runner Menu
let g:lmap.r = {"name": "Runner Menu"}
let g:lmap.r.h = "Run dot-http on the line that the cursor is currently on"

" Session Menu
let g:lmap.s = {"name": "Session Menu"}
let g:lmap.s.s = "Save session"
let g:lmap.s.l = "Load session"

" Toggle Menu
let g:lmap.t = {"name": "Toggler Menu"}
let g:lmap.t.c = "Change colorscheme"
let g:lmap.t.e = "Toggle Tree Explorer"
let g:lmap.t.m = "Toggle Minimap"
let g:lmap.t.n = "Toggle Line Numbers"
let g:lmap.t.q = "Auto toggle nvim-bqf"
let g:lmap.t.s = "Open start screen"
let g:lmap.t.T = "Toggle Tags view"
let g:lmap.t.t = "Toggle terminal"

" Display menus with a `+` in-front of the description (à la emacs-which-key).
let g:leaderGuide_display_plus_menus = 1
" Register the dictionary
call leaderGuide#register_prefix_descriptions('<Space>', 'g:lmap')
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
