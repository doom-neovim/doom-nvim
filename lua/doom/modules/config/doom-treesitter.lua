return function()
	local doomrc = require('doom.core.config.doomrc').load_doomrc()
	local functions = require('doom.core.functions')

	local function get_ts_parsers(languages)
		local langs = {}

		for _, lang in ipairs(languages) do
			-- If the lang is config then add parsers for JSON, YAML and TOML
			if lang == 'config' then
				table.insert(langs, 'json')
				table.insert(langs, 'yaml')
				table.insert(langs, 'toml')
			else
				lang = lang:gsub('%s+%+lsp', '')
				table.insert(langs, lang)
			end
		end
		return langs
	end

	require('nvim-treesitter.configs').setup({
		ensure_installed = get_ts_parsers(doomrc.langs),
		highlight = { enable = true },
		autopairs = {
			enable = functions.is_plugin_disabled('autopairs') and false or true,
		},
		indent = { enable = true },
	})
end
