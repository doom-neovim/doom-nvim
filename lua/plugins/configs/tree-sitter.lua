local ts = require('nvim-treesitter.configs')
--[[
    Here you can use the maintained value which indicates that we wish to use all
    maintained languages modules instead of a list of languages. You also need to
    set highlight to true, otherwise the plugin will be disabled.
--]]
ts.setup({
	-- NOTE: Place your languages here!
	ensure_installed = Doom.ts_parsers,
	highlight = { enabled = true },
	indent = { enabled = true },
})
