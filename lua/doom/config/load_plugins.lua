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
if fn['doom#functions#checkplugin']('which-key.nvim') == 1 then
	require('plugins.configs.which-key')
end
if fn['doom#functions#checkplugin']('symbols-outline.nvim') == 1 then
	require('plugins.configs.symbols')
end
if fn['doom#functions#checkplugin']('auto-session') == 1 then
	require('plugins.configs.auto-session')
end
if fn['doom#functions#checkplugin']('format.nvim') == 1 then
	require('plugins.configs.nvim-format')
end
