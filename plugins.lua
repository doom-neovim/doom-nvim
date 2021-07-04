-- plugins - Doom nvim custom plugins
--
-- This file contains all the custom plugins that are not in Doom nvim but that
-- the user requires. All the available fields can be found here
-- https://github.com/wbthomason/packer.nvim#specifying-plugins
--
-- By example, for including a plugin with a dependency on telescope:
-- return {
--     {
--         'user/repository',
--         requires = { 'nvim-lua/telescope.nvim' },
--     },
-- }

return {
	-- Languages support
	{
		'cheap-glitch/vim-v',
		disable = false,
	},
	-- Documentations
	{
		'milisims/nvim-luaref',
		event = 'VimEnter',
	},
	{
		'nanotee/luv-vimdocs',
		event = 'VimEnter',
	},
	-- Misc
	{
		'andweeb/presence.nvim',
		config = function()
			require('presence'):setup({
				log_level = 'error',
				enable_line_number = true,
			})
		end,
		event = 'ColorScheme',
	},
	-- Colorschemes
	'eddyekofo94/gruvbox-flat.nvim',
}
