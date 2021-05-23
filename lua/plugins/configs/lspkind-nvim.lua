return function()
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
