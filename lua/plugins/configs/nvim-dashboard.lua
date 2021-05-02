local plugins_count =
	Fn.len(Fn.globpath('~/.local/share/nvim/site/pack/packer/start', '*', 0, 1))

G.dashboard_session_directory = Doom_root .. '/sessions'
G.dashboard_default_executive = 'telescope'
G.dashboard_custom_shortcut = {
	['last_session'] = 'SPC s l',
	['find_history'] = 'SPC f h',
	['find_file'] = 'SPC f f',
	['new_file'] = 'SPC f n',
	['change_colorscheme'] = 'SPC t c',
	['find_word'] = 'SPC f W',
	['book_marks'] = 'SPC f b',
}

G.dashboard_custom_footer = {
	'Doom Nvim loaded ' .. plugins_count .. ' plugins',
}

G.dashboard_custom_header = {
	'=================     ===============     ===============   ========  ========',
	'\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //',
	'||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||',
	'|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||',
	'||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||',
	'|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||',
	"||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
	'|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||',
	"||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
	"||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
	"||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
	"||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
	"||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
	"||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
	"||   .=='    _-'          `-__\\._-'         `-_./__-'         `' |. /|  |   ||",
	"||.=='    _-'                                                     `' |  /==.||",
	"=='    _-'                        N E O V I M                         \\/   `==",
	"\\   _-'                                                                `-_   /",
	" `''                                                                      ``'  ",
	'                                                                               ',
}

-- Header color
Cmd('hi! dashboardHeader   guifg=#586268')
Cmd('hi! dashboardCenter   guifg=#51afef')
Cmd('hi! dashboardShortcut guifg=#9788b9')
Cmd('hi! dashboardFooter   guifg=#586268')
