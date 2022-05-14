local scim = {}

-- start building the scim plugin here.

scim.cmds = {
  { "ScimCreate", function()
    -- create buffer.
    -- run scim inside of it
  end },
{ "ScimClose", function()
    -- if current buf = scim
    -- close
  end}
}

return scim
