---[[---------------------------------------]]---
--        main.vim - Core of Doom Nvim         --
--            Author: NTBBloodbath             --
--            License: MIT                     --
---[[---------------------------------------]]---
-- If packer.nvim is not installed then install it
local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_install_path)) > 0 then
    execute('silent !git clone https://github.com/wbthomason/packer.nvim ' ..
                packer_install_path)
    execute 'packadd packer.nvim'
end

-- Set some configs on load
if fn.has('vim_starting') == 1 then
    -- Set encoding
    opt('o', 'encoding', 'utf-8')
    -- Required to use some colorschemes and improve colors
    opt('o', 'termguicolors', true)
end

-- Start Doom and run packer.nvim
fn['doom#begin']()
require('plugins')

-- /home/user/.config/doom-nvim/lua/plugins/init.lua
-- /home/user/.config/doom-nvim/lua/plugins/configs/*.lua
-- Don't load plugin config if the plugin is disabled to improve performance
if fn['doom#functions#checkplugin']('nvim-autopairs') == 1 then
    require('plugins.configs.autopairs')
end
if fn['doom#functions#checkplugin']('nvim-lspconfig') == 1 then
    require('plugins.configs.lsp')
end
if fn['doom#functions#checkplugin']('nvim-colorizer.lua') == 1 then
    require('plugins.configs.nvim-colorizer')
end
if fn['doom#functions#checkplugin']('nvim-compe') == 1 then
    require('plugins.configs.nvim-compe')
end
if fn['doom#functions#checkplugin']('focus.nvim') == 1 then
    require('plugins.configs.nvim-focus')
end
if fn['doom#functions#checkplugin']('telescope.nvim') == 1 then
    require('plugins.configs.nvim-telescope')
end
if fn['doom#functions#checkplugin']('nvim-toggleterm.lua') == 1 then
    require('plugins.configs.nvim-toggleterm')
end
if fn['doom#functions#checkplugin']('nvim-tree.lua') == 1 then
    require('plugins.configs.nvim-tree')
end
if fn['doom#functions#checkplugin']('galaxyline.nvim') == 1 then
    require('plugins.configs.statusline')
end
if fn['doom#functions#checkplugin']('nvim-treesitter') == 1 then
    require('plugins.configs.tree-sitter')
end
if fn['doom#functions#checkplugin']('gitsigns.nvim') == 1 then
    require('plugins.configs.nvim-gitsigns')
end

fn['doom#end']()
