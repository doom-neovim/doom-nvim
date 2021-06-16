vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
	vim.cmd('syntax reset')
end

vim.g['colors_name'] = 'doom-one'

if vim.opt.background ~= 'dark' then
	vim.opt.background = 'dark'
end

package.loaded['colors.doom-one'] = nil
require('colors.doom-one')
