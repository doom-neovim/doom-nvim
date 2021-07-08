---[[---------------------------------------]]---
--     keybindings - Doom Nvim keybindings     --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

local wk = require('which-key')

-- Define leader key to space
-- and call leader mapper
Map('n', '<Space>', '<Nop>')
Api.nvim_set_var('mapleader', ' ')

-------------------------------------------------

---[[-------------------------------]]---
--          Custom Key Mappings        --
--                                     --
--    <leader>b = Buffer Menu          --
--    <leader>f = File Menu            --
--    <leader>g = Git Menu             --
--    <leader>p = Plugin Menu          --
--    <leader>r = Runner Menu          --
--    <leader>s = Session Menu         --
--    <leader>t = Toggle Menu          --
--    <leader>w = Window Menu          --
--                                     --
--          TAB = Cycle buffers        --
--          ESC = Search highlight off --
--           F2 = Toggle Tagbar        --
--           F3 = Toggle Tree Explorer --
--           F4 = Toggle Terminal      --
--           F5 = Toggle Minimap       --
--           F6 = Toggle Zen Mode      --
--           F7 = Run restclient       --
---]]-------------------------------[[---

-------------------------------------------------

-- Additional options for mappings
local opts = { silent = true }

---[[-----------------]]---
--    LSP Keybindings    --
---]]-----------------[[---
-- If the LSP group is not disabled or the nvim-compe plugin is not disabled
-- then set its mappings.
if
	not Has_value(Doom.disabled_modules, 'lsp')
	and (not Has_value(Doom.disabled_plugins, 'compe'))
	and Check_plugin('nvim-compe')
then
    local compe_opts = { silent = true, expr = true }
	-- https://github.com/hrsh7th/nvim-compe#mappings
	Map('i', '<C-Space>', 'compe#complete("<C-space>")', compe_opts)
	Map('i', '<CR>', 'compe#confirm("<CR>")', compe_opts)
	Map('i', '<C-e>', 'compe#close("<C-e>")', compe_opts)
	Map('i', '<C-f>', 'compe#scroll({ "delta": +4 })', compe_opts)
	Map('i', '<C-d>', 'compe#scroll({ "delta": -4 })', compe_opts)
	Map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts) -- gd: jump to definitionA
	Map('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts) -- gr: go to reference
	Map('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts) -- gi: buf implementation
	Map('n', 'ca', ':Lspsaga code_action<CR>', opts) -- ca: code actions
	Map('n', 'K', ':Lspsaga hover_doc<CR>', opts) -- K: hover doc
	Map('n', '<C-p>', ':Lspsaga diagnostic_jump_prev<CR>', opts) -- Control+p: Jump to previous diagnostic
	Map('n', '<C-n>', ':Lspsaga diagnostic_jump_next<CR>', opts) -- Control+n: Jump to next diagnostic
	Map(
		'n',
		'<C-f>',
		':lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>',
		opts
	) -- Control+f: Scroll down documents
	Map(
		'n',
		'<C-b>',
		"lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>"
	) -- Control+b: Scroll up documents
	Cmd(
		'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()'
	)
end

if Doom.new_file_split then
	Map('n', '<Leader>fn', ':new<CR>', opts)
else
	Map('n', '<Leader>fn', ':enew<CR>', opts)
end

-- TAB to cycle buffers too, why not?
Map('n', '<Tab>', ':bnext<CR>', opts)
Map('n', '<S-Tab>', ':bprevious<CR>', opts)

-- ESC to turn off search highlighting
Map('n', '<esc>', ':noh<CR>', opts)

--- F<n> keybindings
if not Has_value(Doom.disabled_plugins, 'tagbar') then
	Map('n', '<F2>', ':SymbolsOutline<CR>')
end
if not Has_value(Doom.disabled_plugins, 'tree') then
	Map('n', '<F3>', ':NvimTreeToggle<CR>')
end
if not Has_value(Doom.disabled_plugins, 'terminal') then
	Map('n', '<F4>', ':ToggleTerm<CR>')
end
if not Has_value(Doom.disabled_plugins, 'minimap') then
	Map('n', '<F5>', ':MinimapToggle<CR>')
end
if not Has_value(Doom.disabled_plugins, 'zen') then
	Map('n', '<F6>', ':TZAtaraxis<CR>')
end
if
	not Has_value(Doom.disabled_modules, 'web')
	and (not Has_value(Doom.disabled_plugins, 'restclient'))
then
	Map('n', '<F7>', ':DotHttp<CR>')
end
---[[------------------------------]]
--     Window Movements keys      --
---]]------------------------------]]

Map('n', '<C-h>', '<C-w>h', opts)
Map('n', '<C-j>', '<C-w>j', opts)
Map('n', '<C-k>', '<C-w>k', opts)
Map('n', '<C-l>', '<C-w>l', opts)

---[[-----------------]]---
--     Escape Remaps     --
---]]-----------------[[---
Map('i', 'jk', '<ESC>', opts)

---[[-----------------]]---
--     Select Movement   --
---]]-----------------[[---
Map('x', 'K', ":move '<-2<CR>gv-gv", opts)
Map('x', 'J', ":move '>+1<CR>gv-gv", opts)

Cmd('tnoremap <Esc> <C-\\><C-n>') -- get out of terminal insert mode into normal mode with Esc

---[[-----------------]]---
--     Resizing Splits   --
---]]-----------------[[---
Cmd([[
  nnoremap <silent> <C-Up>    :resize -2<CR>
  nnoremap <silent> <C-Down>  :resize +2<CR>
  nnoremap <silent> <C-Right>  :vertical resize -2<CR>
  nnoremap <silent> <C-Left>  :vertical resize +2<CR>
]])

---[[-----------------]]---
--     Disable keys      --
---]]-----------------[[---
-- Disable accidentally pressing ctrl-z and suspending
Map('n', '<c-z>', '<Nop>')

-- Disable ex mode
Map('n', 'Q', '<Nop>')

-- Disable recording
Map('n', 'q', '<Nop>')

-- Fast exit from Doom Nvim and write messages to logs
Map('n', 'ZZ', ':lua Quit_doom(1, 1)<CR>')

---[[-----------------]]---
--      Leader keys      --
---]]-----------------[[---
-- Buffers
wk.register({
	['<leader>'] = {
		b = {
			name = '+buffer',
			['1'] = { ':BufferGoto 1<CR>', 'Buffer 1' },
			['2'] = { ':BufferGoto 2<CR>', 'Buffer 2' },
			['3'] = { ':BufferGoto 3<CR>', 'Buffer 3' },
			['4'] = { ':BufferGoto 4<CR>', 'Buffer 4' },
			['5'] = { ':BufferGoto 5<CR>', 'Buffer 5' },
			['6'] = { ':BufferGoto 6<CR>', 'Buffer 6' },
			['7'] = { ':BufferGoto 7<CR>', 'Buffer 7' },
			['8'] = { ':BufferGoto 8<CR>', 'Buffer 8' },
			['9'] = { ':BufferLast<CR>', 'Last buffer' },
			c = { ':BufferClose<CR>', 'Close buffer' },
			f = { ':FormatWrite<CR>', 'Format buffer' },
			n = { ':BufferNext<CR>', 'Next buffer' },
			P = { ':BufferPick<CR>', 'Pick buffer' },
			p = { ':BufferPrevious<CR>', 'Previous buffer' },
		},
	},
})

-- Plugins
wk.register({
	['<leader>'] = {
		p = {
			name = '+plugins',
			c = { ':PackerClean<CR>', 'Clean disabled or unused plugins' },
			i = { ':PackerInstall<CR>', 'Install missing plugins' },
			p = {
				':PackerProfile<CR>',
				'Profile the time taken loading your plugins',
			},
			s = {
				':PackerSync<CR>',
				'Performs PackerClean and then PackerUpdate',
			},
			u = { ':PackerUpdate<CR>', 'Update your plugins' },
		},
	},
})

-- Order
wk.register({
	['<leader>'] = {
		o = {
			name = '+order',
			d = { ':BufferOrderByDirectory<CR>', 'Sort by directory' },
			l = { ':BufferOrderByLanguage<CR>', 'Sort by language' },
			n = { ':BufferMoveNext<CR>', 'Re-order buffer to next' },
			p = { ':BufferMovePrevious<CR>', 'Re-order buffer to previous' },
		},
	},
})

-- File
wk.register({
	['<leader>'] = {
		f = {
			name = '+file',
			c = { ':e $MYVIMRC<CR>', 'Edit Neovim configuration' },
			n = { 'Create a new unnamed buffer' },
			f = { ':Telescope find_files<CR>', 'Find files' },
			b = { ':Telescope marks<CR>', 'Bookmarks' },
			W = { ':Telescope live_grep<CR>', 'Find word' },
			t = { ':Telescope help_tags<CR>', 'Help tags' },
			h = { ':Telescope oldfiles<CR>', 'Recently opened files' },
			w = { ':SudaWrite<CR>', 'Write file with sudo permissions' },
			r = { ':SudaRead<CR>', 'Re-open file with sudo permissions' },
		},
	},
})

-- Window
wk.register({
	['<leader>'] = {
		w = {
			name = '+window',
			C = { ':only<CR>', 'Close all other windows' },
			c = { ':close<CR>', 'Close current window' },
			h = { ':split<CR>', 'Split horizontally' },
			v = { ':vsplit<CR>', 'Split vertically' },
		},
	},
})

-- Sessions
wk.register({
	['<leader>'] = {
		s = {
			name = '+sessions',
			s = { ':SaveSession<CR>', 'Save current session' },
			r = { ':RestoreSession<CR>', 'Restore previously saved session' },
			l = {
				':Telescope session-lens search_session<CR>',
				'Session switcher',
			},
		},
	},
})

-- Doom Menu
wk.register({
	['<leader>'] = {
		d = {
			name = '+doom',
			c = {
				':e ~/.config/doom-nvim/doomrc<CR>',
				'Edit your Doom Nvim configuration',
			},
			d = { ':help doom_nvim<CR>', 'Open Doom Nvim documentation' },
			u = { ':DoomUpdate<CR>', 'Check Doom Nvim udpates' },
			r = {
				':lua Create_report()<CR>',
				'Create crash report',
			},
		},
	},
})

-- Toggler
wk.register({
	['<leader>'] = {
		t = {
			name = '+toggle',
			s = { ':Dashboard<CR>', 'Open start screen' },
			c = { ':DashboardChangeColorscheme<CR>', 'Change colorscheme' },
			e = { ':NvimTreeToggle<CR>', 'Toggle Tree Explorer' },
			m = { ':MinimapToggle<CR>', 'Toggle Minimap' },
			S = { ':SymbolsOutline<CR>', 'Toggle Symbols view' },
			t = { ':ToggleTerm<CR>', 'Toggle terminal' },
		},
	},
})

-- If web is enabled and restclient is enabled too
if
	not Has_value(Doom.disabled_modules, 'web')
	and (not Has_value(Doom.disabled_plugins, 'restclient'))
then
	wk.register({
		['<leader>'] = {
			r = {
				name = '+runner',
				r = {
					':DotHttp<CR>',
					'Run restclient on the line that the cursor is currently on',
				},
			},
		},
	})
end

-- If LSP is enabled
if
	not Has_value(Doom.disabled_modules, 'lsp')
	and (not Has_value(Doom.disabled_plugins, 'compe'))
then
	wk.register({
		['<leader>'] = {
			l = {
				name = '+lsp',
				d = {
					'<cmd>lua vim.lsp.buf.type_definition()<CR>',
					'Show type definition',
				},
				l = {
					'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
					'Show line diagnostics',
				},
				L = {
					'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
					'Diagnostics into location list',
				},
			},
		},
	})
end

-- If Git is enabled
if not Has_value(Doom.disabled_modules, 'git') then
	wk.register({
		['<leader>'] = {
			g = {
				name = '+git',
				o = { ':LazyGit<CR>', 'Open LazyGit' },
				P = { ':TermExec cmd="git pull"<CR>', 'Pull' },
				p = { ':TermExec cmd="git push"<CR>', 'Push' },
				S = { 'Stage hunk' },
				s = { ':TermExec cmd="git status"<CR>', 'Status' },
				u = { 'Undo stage hunk' },
				R = { 'Reset buffer' },
				r = { 'Reset hunk' },
				h = { 'Preview hunk' },
				b = { 'Blame line' },
			},
		},
	})
end
