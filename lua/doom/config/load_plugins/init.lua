---[[---------------------------------------]]---
--    load_plugins - Load Doom Nvim Plugins    --
--              Author: NTBBloodbath           --
--              License: MIT                   --
---[[---------------------------------------]]---

-- /home/user/.config/doom-nvim/lua/plugins/init.lua
-- /home/user/.config/doom-nvim/lua/plugins/configs/*.lua
-- Don't load plugin config if the plugin is disabled to improve performance
if Check_plugin('pears.nvim') then
	require('plugins.configs.nvim-pears')
end
if Check_plugin('nvim-lspconfig') and (Check_plugin('nvim-lspinstall')) then
	require('plugins.configs.lsp')
end
if Check_plugin('nvim-compe') then
	require('plugins.configs.nvim-compe')
end
if Check_plugin('nvim-colorizer.lua') then
	require('plugins.configs.nvim-colorizer')
end
if Check_plugin('focus.nvim') then
	require('plugins.configs.nvim-focus')
end
if Check_plugin('telescope.nvim') then
	require('plugins.configs.nvim-telescope')
end
if Check_plugin('nvim-toggleterm.lua') then
	require('plugins.configs.nvim-toggleterm')
end
if Check_plugin('nvim-tree.lua') then
	require('plugins.configs.nvim-tree')
end
if Check_plugin('galaxyline.nvim') then
	require('plugins.configs.statusline')
end
if Check_plugin('nvim-treesitter') then
	require('plugins.configs.tree-sitter')
end
if Check_plugin('gitsigns.nvim') then
	require('plugins.configs.nvim-gitsigns')
end
if Check_plugin('which-key.nvim') then
	require('plugins.configs.which-key')
end
if Check_plugin('symbols-outline.nvim') then
	require('plugins.configs.symbols')
end
if Check_plugin('auto-session') then
	require('plugins.configs.auto-session')
end
if Check_plugin('format.nvim') then
	require('plugins.configs.nvim-format')
end
if Check_plugin('nvim-web-devicons') then
	require('plugins.configs.nvim-devicons')
end
if Check_plugin('dashboard-nvim') then
	require('plugins.configs.nvim-dashboard')
end
if Check_plugin('indent-blankline.nvim') then
	require('plugins.configs.blankline')
end
