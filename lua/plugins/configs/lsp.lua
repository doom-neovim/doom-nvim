-- taken from https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local nvim_lsp = require('lspconfig')

-- Snippets support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Signature help
require('lsp_signature').on_attach()

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

local on_attach = function(client, bufnr)
	local function buf_set_option(...)
		Api.nvim_buf_set_option(bufnr, ...)
	end
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- Mappings.
	local opts = { silent = true }
	Map(
		'n',
		'ga',
		'<Cmd>lua vim.lsp.buf.code_action()<CR>',
		opts
	)
	Map(
		'n',
		'gD',
		'<Cmd>lua vim.lsp.buf.declaration()<CR>',
		opts
	)
	Map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	Map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	Map(
		'n',
		'gi',
		'<cmd>lua vim.lsp.buf.implementation()<CR>',
		opts
	)
	Map(
		'n',
		'<C-k>',
		'<cmd>lua vim.lsp.buf.signature_help()<CR>',
		opts
	)
	Map(
		'n',
		'<space>wa',
		'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
		opts
	)
	Map(
		'n',
		'<space>wr',
		'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
		opts
	)
	Map(
		'n',
		'<space>wl',
		'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
		opts
	)
	Map(
		'n',
		'<space>D',
		'<cmd>lua vim.lsp.buf.type_definition()<CR>',
		opts
	)
	Map(
		'n',
		'<space>rn',
		'<cmd>lua vim.lsp.buf.rename()<CR>',
		opts
	)
	Map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	Map(
		'n',
		'<space>e',
		'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
		opts
	)
	Map(
		'n',
		'[d',
		'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
		opts
	)
	Map(
		'n',
		']d',
		'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
		opts
	)
	Map(
		'n',
		'<space>q',
		'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
		opts
	)
	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		Map(
			'n',
			'<space>f',
			'<cmd>lua vim.lsp.buf.formatting()<CR>',
			opts
		)
	elseif client.resolved_capabilities.document_range_formatting then
		Map(
			'n',
			'<space>f',
			'<cmd>lua vim.lsp.buf.range_formatting()<CR>',
			opts
		)
	end
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		Api.nvim_exec(
			[[
        hi LspReferenceRead ctermbg=237 guibg=LightYellow
        hi LspReferenceText ctermbg=237 guibg=LightYellow
        hi LspReferenceWrite ctermbg=237 guibg=LightYellow
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
			false
		)
	end
end

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
