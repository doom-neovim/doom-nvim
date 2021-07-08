---[[---------------------------------------]]---
--    load_plugins - Load Doom Nvim Plugins    --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

-- /home/user/.config/doom-nvim/lua/plugins/init.lua
-- /home/user/.config/doom-nvim/lua/plugins/configs/*.lua
-- Don't load plugin config if the plugin is disabled to improve performance

-- Defines the list of plugins to conditionally load
local conditional_plugins = {

	-- Format: ['file-to-require'] = 'plugin-to-check' OR ['file-to-require'] = { 'plugins', 'to', 'check' }
	['autopairs'] = 'nvim-autopairs',
	['lsp'] = { 'nvim-lspconfig', 'nvim-lspinstall' },
	['nvim-compe'] = 'nvim-compe',
	['nvim-colorizer'] = 'nvim-colorizer.lua',
	['nvim-telescope'] = 'telescope.nvim',
	['nvim-toggleterm'] = 'nvim-toggleterm.lua',
	['nvim-tree'] = 'nvim-tree.lua',
	['statusline'] = 'galaxyline.nvim',
	['tree-sitter'] = 'nvim-treesitter',
	['nvim-gitsigns'] = 'gitsigns.nvim',
	['which-key'] = 'which-key.nvim',
	['symbols'] = 'symbols-outline.nvim',
	['auto-session'] = 'auto-session',
	['nvim-format'] = 'format.nvim',
	['nvim-devicons'] = 'nvim-web-devicons',
	['nvim-dashboard'] = 'dashboard-nvim',
	['blankline'] = 'indent-blankline.nvim'

}

-- Loop through all conditional plugins and see whether we need to load them
for file_to_require, plugins_to_check in pairs(conditional_plugins) do

	-- The plugins_to_check value can be either an array of strings or a single string
	local type_of_plugin = type(plugins_to_check)

	if type_of_plugin == 'string' then
		if Check_plugin(plugins_to_check) then
			require('plugins.configs.' .. file_to_require)
		end
	elseif type_of_plugin == 'table' then

		-- If we're dealing with a table then loop through it and see if all plugins want to be loaded
		local success = true

		for _, plugin in ipairs(plugins_to_check) do
			if not Check_plugin(plugin) then -- If even one of those plugins isn't wanted do not load our file
				success = false
				break
			end
		end

		if success then
			require('plugins.configs.' .. file_to_require)
		end
	end
end
