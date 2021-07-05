---[[---------------------------------------]]---
--     keybindings - Doom Nvim keybindings     --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

local utils = require('doom.utils')
local log = require('doom.core.logging')
local config = require('doom.core.config').load_config()
local functions = require('doom.core.functions')

log.debug('Loading Doom keybindings module ...')

-- Additional options for mappings
local opts = { silent = true }
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
-- If the LSP group is not disabled or the nvim-compe plugin is not disabled
-- then set its mappings.
if
	functions.check_plugin('nvim-compe', 'opt')
then
	-- https://github.com/hrsh7th/nvim-compe#mappings
	utils.map('i', '<expr> <C-Space>', 'compe#complete()', opts)
	utils.map('i', '<expr> <CR>', 'compe#confirm("<CR>")', opts)
	utils.map('i', '<expr> <C-e>', 'compe#close("<C-e>")', opts)
	utils.map(
		'i',
		'<expr> <C-f>',
		'compe#scroll({ "delta": +4 })',
		opts
	)
	utils.map(
		'i',
		'<expr> <C-d>',
		'compe#scroll({ "delta": -4 })',
		opts
	)
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
--[[ if not utils.has_value(Doom.disabled_plugins, 'outline') then
	utils.map('n', '<F2>', ':SymbolsOutline<CR>', opts)
end
if not utils.has_value(Doom.disabled_plugins, 'tree') then
	utils.map('n', '<F3>', ':NvimTreeToggle<CR>', opts)
end
if not utils.has_value(Doom.disabled_plugins, 'minimap') then
	utils.map('n', '<F5>', ':MinimapToggle<CR>', opts)
end
if not utils.has_value(Doom.disabled_plugins, 'zen') then
	utils.map('n', '<F6>', ':TZAtaraxis<CR>', opts)
end
if
	not utils.has_value(Doom.disabled_modules, 'web')
	and (not utils.has_value(Doom.disabled_plugins, 'restclient'))
then
	utils.map('n', '<F7>', ':<Plug>RestNvim<CR>', opts)
end ]]
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
--     Select Movement   --
---]]-----------------[[---
utils.map('x', 'K', ":move '<-2<CR>gv-gv", opts)
utils.map('x', 'J', ":move '>+1<CR>gv-gv", opts)

vim.cmd('tnoremap <Esc> <C-\\><C-n>') -- get out of terminal insert mode into normal mode with Esc

---[[-----------------]]---
--     Resizing Splits   --
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

-- Disable recording
utils.map('n', 'q', '<Nop>', opts)

-- Fast exit from Doom Nvim and write messages to logs
utils.map(
	'n',
	'ZZ',
	':lua require("doom.core.functions").quit_doom(1, 1)<CR>',
	opts
)
