return function()
	local nvim_lsp = require('lspconfig')

	--[[-----------------]]
	--
	--      LSP Setup      --
	--]]-----------------[[--
	-- https://github.com/kabouzeid/nvim-lspinstall#advanced-configuration-recommended
	local function setup_servers()
		-- Provide the missing :LspInstall
		require('lspinstall').setup()
		local servers = require('lspinstall').installed_servers()
		for _, server in pairs(servers) do
			nvim_lsp[server].setup({})
		end
	end

	setup_servers()

	-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
	require('lspinstall').post_install_hook = function()
		setup_servers() -- reload installed servers
		Cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
	end
end
