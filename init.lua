---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: MIT                    --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------

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
    -- Load main configurations
    require('doom.config')
    -- UI settings
    require('doom.config.ui')
    -- Doom keybindings
    require('doom.keybindings')
    -- Doom autocommands
    require('doom.autocmds')

    if vim.api.nvim_buf_get_name(0):len() == 0 then 
        vim.cmd("Dashboard")
    end

    async:close()

end))

async:send()
