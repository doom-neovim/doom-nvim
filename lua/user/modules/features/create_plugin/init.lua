local create_plugin = {}

-- cmd:
--
--    clone and fork plugin/repo/url (are you sure yes/no?) under cursor in a module with ghm.
--
--

create_plugin.cmd = {
  { "CreatePlugin", function() end },
  { "CreatePluginMigrateByname", function()
    -- 1. prepend doom- prefix
    -- 2. add `.nvim` extension
    -- 3. format `_` to `-` in name.
    -- 4. use BOILIT to generate plugin template.
    -- 5. move module segments into plugin files.
    -- 6. assign the plugin path to variable.
    -- 7. use REFACTOR to migrate chunks
    -- 8. add plugin to GHQ
    -- 9.
  end },
}

return create_plugin
