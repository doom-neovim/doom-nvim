local scim = {}

-- start building the scim plugin here.
--
-- FIRST: need to have the settings.term_exec_str

scim.cmds = {
  { "ScimCreate", function()
    -- create buffer.
    -- run scim inside of it
  end },
  { "ScimOpen", function()
    -- create buffer.
    -- open scim file path in buffer.
  end },
{ "ScimClose", function()
    -- if current buf = scim
    -- close
  end}
}

return scim
