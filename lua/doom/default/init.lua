---[[---------------------------------------]]---
--         default - Doom Nvim defaults        --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

-- Set and load default options
function Default_options()
    ----- Default Neovim configurations
	-- Set colorscheme
	Cmd('colorscheme ' .. Doom.colorscheme)
	Cmd('set background=' .. Doom.colorscheme_bg)

	-- Set default options
	Cmd('syntax on')
	Cmd('filetype plugin indent on')
	Opt('o', 'encoding', 'utf-8')

	-- Global options
	Opt('o', 'wildmenu', true)
	Opt('o', 'autoread', true)
	Opt('o', 'smarttab', true)
	Opt('o', 'splitright', true)
	Opt('o', 'splitbelow', true)
	Cmd('set noswapfile')
	Cmd('set noshowmode')
	Opt('o', 'hidden', true)
	Opt('o', 'hlsearch', true)
	Opt('o', 'mouse', 'a')
	Opt('o', 'laststatus', 2)
	Opt('o', 'backspace', 'indent,eol,start')
	Opt('o', 'updatetime', 100)
	Opt('o', 'timeoutlen', 200)
	Opt(
		'o',
		'completeopt',
		'menu,menuone,preview,noinsert,noselect'
	)
	Opt('o', 'clipboard', 'unnamedplus')
    Cmd('set shortmess += "atsc"')
	Opt('o', 'inccommand', 'split')
	Opt('o', 'scrolloff', 4)
	Opt('o', 'path', '**')

	-- Buffer options
	Opt('b', 'autoindent', true)
	Opt('b', 'smartindent', true)

	-- Window options
	Cmd('set nowrap')
	Opt('o', 'signcolumn', 'yes')

    -- Set numbering
	if Doom.relative_num then
		Cmd('set nu rnu')
	else
		Cmd('set nu')
	end

    -- Set local-buffer options
    if Doom.expand_tabs then
	Execute('let &expandtab = 1')
    else
	Execute('let &expandtab = 0')
    end
	Execute('let &tabstop = ' .. Doom.indent)
	Execute('let &shiftwidth = ' .. Doom.indent)
	Execute('let &softtabstop = ' .. Doom.indent)
	Execute('let &colorcolumn = ' .. Doom.max_columns)
	Execute('let &conceallevel = ' .. Doom.conceallevel)
end

-- Custom Doom Nvim commands
function Custom_commands()
	-- Set a custom command to update Doom Nvim
	-- can be called by using :DoomUpdate
	Cmd('command! DoomUpdate !git -C ~/.config/doom-nvim/ stash -q && git -C ~/.config/doom-nvim/ pull && git -C ~/.config/doom-nvim/ stash pop -q')
end
