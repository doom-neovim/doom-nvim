local plugins_count =
	Fn.len(Fn.globpath('~/.local/share/nvim/site/pack/packer/start', '*', 0, 1))

G.dashboard_session_directory = Doom_root .. '/sessions'
G.dashboard_default_executive = 'telescope'

G.dashboard_custom_section = {
    a = {description = {'  Reload Last Session            SPC s r'}, command = 'SessionLoad'},
    b = {description = {'  Recently Opened Files          SPC f h'}, command = 'Telescope oldfiles'},
    c = {description = {'  Jump to Bookmark               SPC f b'}, command = 'Telescope marks'},
    d = {description = {'  Find File                      SPC f f'}, command = 'Telescope find_files'},
    e = {description = {'  Find Word                      SPC f g'}, command = 'Telescope live_grep'},
    f = {description = {'  Open Private Configuration     SPC d c'}, command = ':e ~/.config/nvim/doomrc'},
    g = {description = {'  Open Documentation             SPC d d'}, command = ':h doom_nvim'},
}

G.dashboard_custom_footer = {
	'Doom Nvim loaded ' .. plugins_count .. ' plugins',
}

if not Doom.dashboard_statline then
    G.dashboard_disable_statusline = 1
end

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
