local log = require('doom.utils.logging')

local module = {}

--- Stores the unique null_ls sources
local registered_sources = {}
--- Registers a null_ls source only if it's unique
-- @tparam  source
module.use_null_ls_source = function(sources)
  local null_ls = require("null-ls")
  for _, source in ipairs(sources) do
    -- Generate a unique key from the name/methods
    local methods = type(source.method) == 'string' and source.method or table.concat(source.method, ' ')
    local key = source.name .. methods
    -- If it's unique, register it
    if not table[key] then
      table[key] = source
      null_ls.register(source)
    else
      log.warn(string.format('Attempted to register a duplicate null_ls source. ( %s with methods %s).', source.name, methods))
    end
  end
end

return module
