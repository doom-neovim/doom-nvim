local opts = require('doom.modules.built-in.help.options')

local M = {}

M.setup = function(options)
    vim.tbl_extend('force', opts.defaults, options)
end

M.open = function()
end

M.close = function()
end

M.toggle = function()
end

return M
