lua << EOF
vim.cmd('hi clear')
vim.cmd('syntax reset')

vim.g['colors_name'] = 'doom-one'

if vim.opt.background:get() ~= 'dark' then
    vim.opt.background = 'dark'
end

package.loaded['colors.doom-one'] = nil
require('colors.doom-one')
EOF
