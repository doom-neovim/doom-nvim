local utils = require("doom.utils")
local is_module_enabled = utils.is_module_enabled

local utils_modules = {}

-- @param str | table -> list of module categories
utils_modules.get_modules = function(requested_modules)
  local modules_result = {}
  -- if requested_modules == string
  -- 	user ->
  -- 	core -> ?
  --
  -- else table
  -- end

  return modules_result
end

utils_modules.create_new_module = function()
  --
end

-- TODO: sketch structures etc with comments

utils_modules.get_module_template_from_name = function(mname)
  local header = string.format(
    [[local %s = {}

-- TODO:
--
--    -
	]],
    mname
  )

  local settings = string.format(
    [[----------------------------
-- SETTINGS
----------------------------

-- %s.settings = {}
	]],
    mname
  )

  local packages = string.format(
    [[----------------------------
-- PACKAGES
----------------------------

-- %s.packages = {
-- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- }
  ]],
    mname
  )

  local configs = string.format(
    [[----------------------------
-- CONFIGS
----------------------------
  ]],
    mname
  )

  local cmds = string.format(
    [[----------------------------
-- CMDS
----------------------------

-- %s.cmds = {}
  ]],
    mname
  )

  local autocmds = string.format(
    [[--------------------------
-- AUTOCMDS
--------------------------

-- %s.autocmds = {}
	]],
    mname
  )

  local binds = string.format(
    [[----------------------------
-- BINDS
----------------------------

-- %s.binds = {}
  ]],
    mname
  )

  local binds_leader = string.format(
    [[----------------------------
-- LEADER BINDS
----------------------------

-- if require("doom.utils").is_module_enabled("whichkey") then
--   table.insert(%s.binds, {
--     "<leader>",
--     name = "+prefix",
--     {
--       {
--         "YYY",
--         name = "+ZZZ",
--         {
--         -- first level
--         },
--       },
--     },
--   })
-- end
  ]],
    mname
  )

  local footer = string.format(
    [[----------------------------
-- RETURN
----------------------------

return %s
  ]],
    mname
  )

  return string.format(
    [[%s
%s
%s
%s
%s
%s
%s
%s
%s
  ]],
    header,
    settings,
    packages,
    configs,
    cmds,
    autocmds,
    binds,
    binds_leader,
    footer
  )
end

return utils_modules
