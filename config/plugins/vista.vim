" Position to open the vista sidebar only
if g:doom_tagbar_left ==# 1
	let g:vista_sidebar_position = 'vertical topleft'
else
	let g:vista_sidebar_position = 'vertical botright'
endif

" Sidebar width
let g:vista_sidebar_width = g:doom_sidebar_width

" Executive used when opening vista sidebar without specifying it.
let g:vista_default_executive = 'nvim_lsp'

" Set how to show the detailed information of the current cursor symbol
let g:vista_echo_cursor_strategy = 'both'

" Close the vista window automatically when you jump to a symbol
let g:vista_close_on_jump = 1

" Ensure you have installed some decent font to show these pretty symbols,
" then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it
" as you wish.
let g:vista#renderer#icons = {
			\ "function": "\uf794",
			\ "variable": "\uf71b",
			\}
