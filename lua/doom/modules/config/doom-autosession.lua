return function()
    local config = require('doom.core.config').load_config()
	require('auto-session').setup({
		-- Sets the log level of the plugin (debug, info, error)
		logLevel = 'info',
		-- Root dir where sessions will be stored (/home/user/.config/nvim/sessions/)
		auto_session_root_dir = vim.fn.stdpath('data') .. '/sessions/',
		-- Enables/disables auto save/restore
		auto_session_enabled = config.doom.autosave_sessions,
		-- Enable keeping track and loading of the last session
		auto_session_enable_last_session = config.doom.autoload_last_session,
	})
end
