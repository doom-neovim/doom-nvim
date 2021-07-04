return function()
	local nvim_lsp = require('lspconfig')

	--[[-----------------]]--
	--      LSP Setup      --
	--]]-----------------[[--
	-- https://github.com/kabouzeid/nvim-lspinstall#advanced-configuration-recommended
	local function setup_servers()
		-- Provide the missing :LspInstall
		require('lspinstall').setup()
		local servers = require('lspinstall').installed_servers()
		for _, server in pairs(servers) do
			-- Configure sumneko to neovim lua development
			if server == 'lua' then
				local lua_path = vim.split(package.path, ';')
				table.insert(lua_path, 'lua/?.lua')
				table.insert(lua_path, 'lua/?/init.lua')

				nvim_lsp[server].setup({
					settings = {
						Lua = {
							awakened = { cat = true },
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = 'LuaJIT',
								-- Setup your lua path
								path = lua_path,
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { 'vim' },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = {},
								maxPreload = 2000,
								preloadFileSize = 150,
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = { enable = false },
						},
					},
				})
			else
				-- Use default settings for all the other language servers
				nvim_lsp[server].setup({})
			end
		end
	end

	setup_servers()

	-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
	require('lspinstall').post_install_hook = function()
		setup_servers() -- reload installed servers
		vim.cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
	end
end
