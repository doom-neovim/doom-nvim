if Check_plugin('lsp_signature.nvim') then
    -- Signature help
    require('lsp_signature').on_attach()
end

if Check_plugin('lspkind-nvim') then
    -- Vscode-like pictograms on completion
    require('lspkind').init({
        with_text = true,
        symbol_map = {
            Text = '',
            Method = 'ƒ',
            Function = '',
            Constructor = '',
            Variable = '',
            Class = '',
            Interface = 'ﰮ',
            Module = '',
            Property = '',
            Unit = '',
            Value = '',
            Enum = '了',
            Keyword = '',
            Snippet = '﬌',
            Color = '',
            File = '',
            Folder = '',
            EnumMember = '',
            Constant = '',
            Struct = '',
        },
    })
end

-- Lsp Symbols
Fn.sign_define('LspDiagnosticsSignError', {
	texthl = 'LspDiagnosticsSignError',
	text = Doom.lsp_error,
	numhl = 'LspDiagnosticsSignError',
})
Fn.sign_define('LspDiagnosticsSignWarning', {
	texthl = 'LspDiagnosticsSignWarning',
	text = Doom.lsp_warning,
	numhl = 'LspDiagnosticsSignWarning',
})
Fn.sign_define('LspDiagnosticsSignHint', {
	texthl = 'LspDiagnosticsSignHint',
	text = Doom.lsp_hint,
	numhl = 'LspDiagnosticsSignHint',
})
Fn.sign_define('LspDiagnosticsSignInformation', {
	texthl = 'LspDiagnosticsSignInformation',
	text = Doom.lsp_information,
	numhl = 'LspDiagnosticsSignInformation',
})

vim.lsp.handlers['textDocument/publishDiagnostics'] =
	vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			prefix = Doom.lsp_virtual_text, -- change this to whatever you want your diagnostic icons to be
		},
	})

return function()
	local nvim_lsp = require('lspconfig')
	-- Snippets support
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport =
		true

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
