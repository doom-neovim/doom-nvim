---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: MIT                    --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------
-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()

-- Disable these for very fast startup time
vim.cmd [[ 
	syntax off
	filetype plugin indent off
]]

-- Utility functions
require('doom.utils')
-- Load default settings
require('doom.default')

local async

async = vim.loop.new_async(vim.schedule_wrap(function()
    -- Logging system
    require('doom.logging')
    -- Doom system detection
    require('doom.system')
    -- Doom functions
    require('doom.functions')

    ---- Doom Configurations ------------------------
    -------------------------------------------------
    -- Load doomrc (user-defined configurations)
    require('doom.config.doomrc')
    -- Load main configurations and plugins
    require('doom.config')
    -- UI settings
    require('doom.config.ui')
    -- Doom keybindings
    require('doom.keybindings')
    -- Doom autocommands
    require('doom.autocmds')

    -- If the current buffer name is empty then trigger Dashboard
    if vim.api.nvim_buf_get_name(0):len() == 0 then
        vim.cmd("Dashboard")
    end

    vim.defer_fn(function()
    	vim.cmd [[ 
    		syntax on
    		bufdo e
    	]]
	end, 15)

    async:close()

end))

async:send()
