-------------------- HELPERS --------------------
api, cmd, fn = vim.api, vim.cmd, vim.fn
keymap, execute, g = api.nvim_set_keymap, api.nvim_command, vim.g
scopes = {o = vim.o, b = vim.bo, w = vim.wo}

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

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        execute('augroup ' .. group_name)
        execute('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            execute(command)
        end
        execute('augroup END')
    end
end

-- Check if string is empty or if it's nil
function is_empty(str)
    return str == '' or str == nil
end

-- try/catch statements, see
-- https://gist.github.com/cwarden/1207556
function catch(err)
    return err[1]
end

function try(block)
    status, result = pcall(block[1])
    if not status then
        block[2](result)
    end
    return result
end
