-------------------- HELPERS --------------------
api, cmd, fn = vim.api, vim.cmd, vim.fn
keymap, execute, g = api.nvim_set_keymap, api.nvim_command, vim.g
scopes = {o = vim.o, b = vim.bo, w = vim.wo}

--- Require packer so we can use `packer.use` function in `custom_plugins` function
local packer = require('packer')

-- Mappings wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L8-L12
function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then default_options = vim.tbl_extend('force', options, opts) end
    keymap(mode, lhs, rhs, options)
end

-- Options wrapper, extracted from
-- https://github.com/ojroques/dotfiles/blob/master/nvim/init.lua#L14-L17
function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-- Check if string is empty or if it's nil
function is_empty(str) return str == '' or str == nil end

-- Search if a table have the value we are looking for,
-- useful for plugins management
function has_value(tabl, val)
    for _, value in ipairs(tabl) do if value == val then return true end end

    return false
end

-- try/catch statements, see
-- https://gist.github.com/cwarden/1207556
function catch(err) return err[1] end

function try(block)
    status, result = pcall(block[1])
    if not status then block[2](result) end
    return result
end

-- A better and less primitive implementation of custom plugins in Doom Nvim
function custom_plugins(plugins)
    -- if a plugin have some configs like enabled or requires then we will
    -- store them in that table
    local plugin_with_configs = {}

    if type(plugins) ~= "string" then
        for idx, val in pairs(plugins) do
            -- Create the correct plugin structure to packer
            -- use {
            --  url,
            --  enabled,
            --  requires
            -- }
            if idx == "repo" then
                table.insert(plugin_with_configs, val)
            end

            if idx == "enabled" then
                if val == 1 then
                    plugin_with_configs['enabled'] = true
                else
                    plugin_with_configs['enabled'] = false
                end
            end

            if idx == "requires" then
                plugin_with_configs['requires'] = val
            end
        end
        -- Send the configured plugin to packer
        packer.use(plugin_with_configs)
    else
        -- Send the simple plugins, e.g. those who have not declared with configs
        -- 'user/repo' ← simple plugin
        -- { 'user/repo', opts } ← configured plugin
        packer.use(plugins)
    end
end
