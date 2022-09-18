local utils = require("doom.utils")
local is_module_enabled = utils.is_module_enabled

-- TODO: MOVE TO UNDER `MODULES/UTILS`??

local templates = {}

templates.gen_temp_from_mod_name = function(mname)
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

return templates

