---[[---------------------------------------]]---
--     keybindings - Doom Nvim keybindings     --
--              Author: NTBBloodbath           --
--              License: GPLv2                 --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')
local config = require('doom.core.config').load_config()
local functions = require('doom.core.functions')

log.debug('Loading Doom keybindings module ...')

-- Additional options for mappings
local opts = { silent = true }

-- selene: allow(undefined_variable)
if not packer_plugins['which-key.nvim'] then
	utils.map('n', '<Space>', '<Nop>', opts)
	vim.g.mapleader = ' '
end

-- Map WhichKey popup menu
utils.map('n', '<Space>', ':WhichKey <leader><CR>', opts)

-------------------------------------------------

---[[---------------------------------]]---
--          Custom Key mappings          --
--                                       --
--    <leader>b = Buffer Menu            --
--    <leader>f = File Menu              --
--    <leader>g = Git Menu               --
--    <leader>p = Plugin Menu            --
--    <leader>r = Runner Menu            --
--    <leader>s = Session Menu           --
--    <leader>t = Toggle Menu            --
--    <leader>w = Window Menu            --
--                                       --
--          TAB = Cycle buffers          --
--          ESC = Search highlight off   --
--           F2 = Toggle Symbols-Outline --
--           F3 = Toggle Tree Explorer   --
--           F4 = Toggle Terminal        --
--           F5 = Toggle Minimap         --
--           F6 = Toggle Zen Mode        --
--           F7 = Run restclient         --
---]]---------------------------------[[---

-------------------------------------------------

---[[-----------------]]---
--    LSP Keybindings    --
---]]-----------------[[---

local lsp_opts = vim.tbl_extend('force', opts, { expr = true })

-- If the LSP is not disabled and compe is installed then set its mappings.
if functions.check_plugin('nvim-compe', 'opt') then
	-- https://github.com/hrsh7th/nvim-compe#mappings
	utils.map('i', '<C-Space>', 'compe#complete()', lsp_opts)
	utils.map('i', '<CR>', 'compe#confirm("<CR>")', lsp_opts)
	utils.map('i', '<C-e>', 'compe#close("<C-e>")', lsp_opts)
	utils.map('i', '<C-f>', 'compe#scroll({ "delta": +4 })', lsp_opts)
	utils.map('i', '<C-d>', 'compe#scroll({ "delta": -4 })', lsp_opts)
	utils.map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts) -- gd: jump to definition
	utils.map('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts) -- gr: go to reference
	utils.map('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts) -- gi: buf implementation
	utils.map('n', 'ca', ':Lspsaga code_action<CR>', opts) -- ca: code actions
	utils.map('n', 'K', ':Lspsaga hover_doc<CR>', opts) -- K: hover doc
	utils.map('n', '<C-p>', ':Lspsaga diagnostic_jump_prev<CR>', opts) -- Control+p: Jump to previous diagnostic
	utils.map('n', '<C-n>', ':Lspsaga diagnostic_jump_next<CR>', opts) -- Control+n: Jump to next diagnostic
	utils.map(
		'n',
		'<C-f>',
		':lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>',
		opts
	) -- Control+f: Scroll down documents
	utils.map(
		'n',
		'<C-b>',
		":lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>",
		opts
	) -- Control+b: Scroll up documents
	vim.cmd(
		'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()'
	)
end

-- LuaSnip mappings
utils.map(
	'n',
	'<Tab>',
	'luasnip#expand_or_jumpable() ? "<Plug>luasnip-expand-or-jump" : "<Tab>"',
	lsp_opts
)
utils.map('i', '<S-Tab>', '<cmd>lua require("luasnip").jump(-1)<CR>', opts)

utils.map('s', '<Tab>', '<cmd>lua require("luasnip").jump(1)<CR>', opts)
utils.map('s', '<S-Tab>', '<cmd>lua require("luasnip").jump(-1)<CR>', opts)

utils.map(
	'i',
	'<C-E>',
	'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"',
	lsp_opts
)
utils.map(
	's',
	'<C-E>',
	'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-E>"',
	lsp_opts
)

if config.doom.new_file_split then
	utils.map('n', '<Leader>fn', ':new<CR>', opts)
else
	utils.map('n', '<Leader>fn', ':enew<CR>', opts)
end

-- TAB to cycle buffers too, why not?
utils.map('n', '<Tab>', ':bnext<CR>', opts)
utils.map('n', '<S-Tab>', ':bprevious<CR>', opts)

-- ESC to turn off search highlighting
utils.map('n', '<esc>', ':noh<CR>', opts)

--- F<n> keybindings
if not functions.is_plugin_disabled('symbols') then
	utils.map('n', '<F2>', ':SymbolsOutline<CR>', opts)
end
if not functions.is_plugin_disabled('explorer') then
	utils.map('n', '<F3>', ':NvimTreeToggle<CR>', opts)
end
if not functions.is_plugin_disabled('minimap') then
	utils.map('n', '<F5>', ':MinimapToggle<CR>', opts)
end
if not functions.is_plugin_disabled('zen') then
	utils.map('n', '<F6>', ':TZAtaraxis<CR>', opts)
end
if not functions.is_plugin_disabled('restclient') then
	utils.map('n', '<F7>', ':<Plug>RestNvim<CR>', opts)
end

---[[------------------------------]]---
--     Window Movements keys          --
---]]------------------------------]]---
utils.map('n', '<C-h>', '<C-w>h', opts)
utils.map('n', '<C-j>', '<C-w>j', opts)
utils.map('n', '<C-k>', '<C-w>k', opts)
utils.map('n', '<C-l>', '<C-w>l', opts)

---[[-----------------]]---
--     Escape Remaps     --
---]]-----------------[[---
utils.map('i', 'jk', '<ESC>', opts)

---[[-----------------]]---
--    Select Movement    --
---]]-----------------[[---
utils.map('x', 'K', ":move '<-2<CR>gv-gv", opts)
utils.map('x', 'J', ":move '>+1<CR>gv-gv", opts)

-- get out of terminal insert mode into normal mode with Esc
vim.cmd('tnoremap <Esc> <C-\\><C-n>')

---[[-----------------]]---
--    Resizing Splits    --
---]]-----------------[[---
vim.cmd([[
  nnoremap <silent> <C-Up>    :resize -2<CR>
  nnoremap <silent> <C-Down>  :resize +2<CR>
  nnoremap <silent> <C-Right> :vertical resize -2<CR>
  nnoremap <silent> <C-Left>  :vertical resize +2<CR>
]])

---[[-----------------]]---
--     Disable keys      --
---]]-----------------[[---
-- Disable accidentally pressing ctrl-z and suspending
utils.map('n', '<c-z>', '<Nop>', opts)

-- Disable ex mode
utils.map('n', 'Q', '<Nop>', opts)

-- Disable recording macros
if config.doom.disable_macros then
	utils.map('n', 'q', '<Nop>', opts)
end

-- Fast exit from Doom Nvim and write messages to logs
utils.map(
	'n',
	'ZZ',
	':lua require("doom.core.functions").quit_doom(true, true)<CR>',
	opts
)

---[[-----------------]]---
--    WhichKey binds     --
---]]-----------------[[---

-- Misc
utils.map('n', '<leader>`', '<cmd>e #<CR>', opts)
utils.map('n', '<leader><space>', '<cmd>Telescope find_files<CR>', opts)
utils.map('n', '<leader>.', '<cmd>Telescope file_browser<CR>', opts)
utils.map(
	'n',
	'<leader>,',
	'<cmd>Telescope buffers show_all_buffers=true<CR>',
	opts
)
utils.map('n', '<leader>/', '<cmd>Telescope live_grep<CR>', opts)
utils.map('n', '<leader>:', '<cmd>Telescope command_history<CR>', opts)

-- Buffers
utils.map(
	'n',
	'<leader>bc',
	'<cmd>lua require("bufferline").handle_close_buffer(vim.fn.bufnr("%"))<CR>',
	opts
)
utils.map('n', '<leader>bb', '<cmd>e #<CR>', opts)
utils.map(
	'n',
	'<leader>b]',
	'<cmd>lua require("bufferline").cycle(1)<CR>',
	opts
)
utils.map(
	'n',
	'<leader>bn',
	'<cmd>lua require("bufferline").cycle(1)<CR>',
	opts
)
utils.map(
	'n',
	'<leader>bg',
	'<cmd>lua require("bufferline").pick_buffer()<CR>',
	opts
)
utils.map(
	'n',
	'<leader>b[',
	'<cmd>lua require("bufferline").cycle(-1)<CR>',
	opts
)
utils.map(
	'n',
	'<leader>bp',
	'<cmd>lua require("bufferline").cycle(-1)<CR>',
	opts
)
utils.map('n', '<leader>bf', '<cmd>FormatWrite<CR>', opts)

-- Doom
utils.map(
	'n',
	'<leader>dc',
	'<cmd>e ~/.config/doom-nvim/doom_config.lua<CR>',
	opts
)
utils.map('n', '<leader>dd', '<cmd>help doom_nvim<CR>', opts)
utils.map('n', '<leader>du', '<cmd>DoomUpdate<CR>', opts)
utils.map('n', '<leader>dr', '<cmd>DoomRollback<CR>', opts)
utils.map(
	'n',
	'<leader>dR',
	'<cmd>lua require("doom.core.functions").create_report()<CR>',
	opts
)
utils.map('n', '<leader>ds', '<cmd>Telescope colorscheme<CR>', opts)

-- Plugins
utils.map('n', '<leader>ps', '<cmd>PackerSync<CR>', opts)
utils.map('n', '<leader>pi', '<cmd>PackerInstall<CR>', opts)
utils.map('n', '<leader>pc', '<cmd>PackerClean<CR>', opts)
utils.map('n', '<leader>pC', '<cmd>PackerCompile<CR>', opts)
utils.map('n', '<leader>pS', '<cmd>PackerStatus<CR>', opts)
utils.map('n', '<leader>pp', '<cmd>PackerProfile<CR>', opts)

-- files
utils.map('n', '<leader>fc', '<cmd>e $MYVIMRC<CR>', opts)
utils.map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)

utils.map('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', opts)
utils.map('n', '<leader>ft', '<cmd>Telescope help_tags<CR>', opts)
utils.map('n', '<leader>fR', '<cmd>SudaRead<CR>', opts)
utils.map('n', '<leader>fw', '<cmd>SudaWrite', opts)

-- search
utils.map('n', '<leader>sg', '<cmd>Telescope live_grep<CR>', opts)
utils.map(
	'n',
	'<leader>sb',
	'<cmd>Telescope current_buffer_fuzzy_find<CR>',
	opts
)
utils.map('n', '<leader>ss', '<cmd>Telescope lsp_document_symbols<CR>', opts)
utils.map('n', '<leader>sh', '<cmd>Telescope command_history<CR>', opts)
utils.map('n', '<leader>sm', '<cmd>Telescope marks<CR>', opts)

-- windows
utils.map('n', '<leader>ww', '<C-W>p', opts)
utils.map('n', '<leader>wd', '<C-W>c', opts)
utils.map('n', '<leader>w-', '<C-W>s', opts)
utils.map('n', '<leader>w|', '<C-W>v', opts)
utils.map('n', '<leader>w2', '<C-W>v', opts)
utils.map('n', '<leader>wh', '<C-W>h', opts)
utils.map('n', '<leader>wj', '<C-W>j', opts)
utils.map('n', '<leader>wl', '<C-W>l', opts)
utils.map('n', '<leader>wk', '<C-W>k', opts)
utils.map('n', '<leader>wH', '<C-W>5<', opts)
utils.map('n', '<leader>wJ', '<cmd>resize +5', opts)
utils.map('n', '<leader>wL', '<C-W>5>', opts)
utils.map('n', '<leader>wK', '<cmd>resize -5', opts)
utils.map('n', '<leader>w=', '<C-W>=', opts)
utils.map('n', '<leader>ws', '<C-W>s', opts)
utils.map('n', '<leader>wv', '<C-W>v', opts)

-- quit / sessions
utils.map(
	'n',
	'<leader>qq',
	'<cmd>lua require("doom.core.functions").quit_doom()<CR>',
	opts
)
utils.map(
	'n',
	'<leader>qw',
	'<cmd>lua require("doom.core.functions").quit_doom(true, true)<CR>',
	opts
)
utils.map('n', '<leader>qs', '<cmd>SaveSession<CR>', opts)
utils.map('n', '<leader>qr', '<cmd>RestoreSession<CR>', opts)
utils.map(
	'n',
	'<leader>ql',
	'<cmd>Telescope session-lens search_session<CR>',
	opts
)

-- toggle
utils.map('n', '<leader>od', '<cmd>Dashboard<CR>', opts)
utils.map('n', '<leader>oe', '<cmd>NvimTreeToggle<CR>', opts)
utils.map('n', '<leader>om', '<cmd>MinimapToggle<CR>', opts)
utils.map('n', '<leader>os', '<cmd>SymbolsOutline<CR>', opts)
utils.map('n', '<leader>ot', '<cmd>ToggleTerm<CR>', opts)

-- git
utils.map('n', '<leader>go', '<cmd>LazyGit<CR>', opts)
utils.map('n', '<leader>gl', '<cmd>TermExec cmd="git pull"<CR>', opts)
utils.map('n', '<leader>gp', '<cmd>TermExec cmd="git push"<CR>', opts)
utils.map('n', '<leader>gs', '<cmd>Telescope git_status<CR>', opts)
utils.map('n', '<leader>gB', '<cmd>Telescope git_branches<CR>', opts)
utils.map('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', opts)

-- code
utils.map('n', '<leader>ch', '<Plug>RestNvim<CR>', opts)
utils.map(
	'n',
	'<leader>ci',
	'<cmd>lua require("doom.modules.built-in.runner").start_repl()<CR>',
	opts
)
utils.map(
	'n',
	'<leader>cr',
	'<cmd>lua require("doom.modules.built-in.runner").run_code()<CR>',
	opts
)
utils.map(
	'n',
	'<leader>cb',
	'<cmd>lua require("doom.modules.built-in.compiler").compile()<cr>',
	opts
)
utils.map(
	'n',
	'<leader>cc',
	'<cmd>lua require("doom.modules.built-in.compiler").compile_and_run()<cr>',
	opts
)

-- lsp
utils.map('n', '<leader>cli', '<cmd>LspInfo<CR>', opts)
utils.map('n', '<leader>cla', '<cmd>Lspsaga code_action<CR>', opts)
utils.map(
	'n',
	'<leader>cld',
	'<cmd>lua vim.lsp.buf.type_definition()<CR>',
	opts
)
utils.map(
	'n',
	'<leader>cll',
	'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
	opts
)
utils.map(
	'n',
	'<leader>clL',
	'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
	opts
)
