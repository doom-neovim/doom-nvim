---[[---------------------------------------]]---
--         default - Doom Nvim defaults        --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---
-- Set and load default options
function Default_options()
    local o = vim.o
    ----- Default Neovim configurations
	-- Set colorscheme
	Cmd('colorscheme ' .. Doom.colorscheme)
	Cmd('set background=' .. Doom.colorscheme_bg)
    Cmd('highlight WhichKeyFloat guibg='..Doom.whichkey_bg)

	-- Set default options
	Cmd('syntax on')
	Cmd('filetype plugin indent on')
	Opt('o', 'encoding', 'utf-8')

	-- Global options
	Opt('o', 'wildmenu', true)
	Opt('o', 'autoread', true)
	Opt('o', 'smarttab', true)
	Opt('o', 'hidden', true)
	Opt('o', 'hlsearch', true)
	Opt('o', 'laststatus', 2)
	Opt('o', 'backspace', 'indent,eol,start')
	Opt('o', 'updatetime', 100)
	Opt('o', 'timeoutlen', 200)
	Opt(
		'o',
		'completeopt',
		'menu,menuone,preview,noinsert,noselect'
	)
    Cmd('set shortmess += "atsc"')
	Opt('o', 'inccommand', 'split')
	Opt('o', 'path', '**')
    --Cmd('set signcolumn=yes')

	-- Buffer options
	Opt('b', 'autoindent', true)
	Opt('b', 'smartindent', true)

    Cmd('set pumheight='..Doom.complete_size)

    -- set Gui Fonts
    --Opt('o', 'guifont='..Doom.guifont..':h'..Doom.guifont_size)
    o.guifont =  Doom.guifont..':h'..Doom.guifont_size

    -- Use clipboard outside vim
    if Doom.clipboard then
        Opt('o', 'clipboard', 'unnamedplus')
    end

    if Doom.line_highlight then
        Cmd('set cursorline')
    else
        Cmd('set nocursorline')
    end

    -- Automatic split locations
    if Doom.split_right then
        Opt('o', 'splitright', true)
    else
        Opt('o', 'splitright', false)
    end

    if Doom.split_below then
        Opt('o', 'splitbelow', true)
    else
        Opt('o', 'splitbelow', false)
    end

    -- Enable scroll off
    if Doom.scrolloff then
        Opt('o', 'scrolloff', Doom.scrolloff_amount )
    end

    -- Enable showmode
    if not Doom.show_mode then
        Cmd('set noshowmode')
    else
        Cmd('set showmode')
    end

    -- Enable mouse input
    if Doom.mouse then
        Opt('o', 'mouse', 'a')
    end

    -- Enable wrapping
    if not Doom.line_wrap then
        Cmd('set nowrap')
    else
        Cmd('set wrap')
    end

    -- Enable swap files
	if not Doom.swap_files then
		Cmd('set noswapfile')
	else
		Cmd('set swapfile')
	end

    -- Set numbering
	if Doom.relative_num then
		Cmd('set nu rnu')
	else
		Cmd('set nu')
	end

    -- Checks to see if undo_dir does not exist. If it doesn't, it will create a undo folder
    local undo_dir = Fn.stdpath('config') ..Doom.undo_dir
    if Doom.backup and Fn.empty(Fn.glob(undo_dir)) > 0 then
        Execute('!mkdir '..undo_dir..' -p')
        Cmd('set undofile')
    end

    -- If backup is false but `undo_dir` still exists then it will delete it.
    if not Doom.backup and Fn.empty(Fn.glob(undo_dir)) ==  0 then
        Execute('!rm -rf '..undo_dir)
        Cmd('set noundofile')
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
