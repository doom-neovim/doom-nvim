local doom_queries = {}

-- TODO:
--
--    - make commands for building queries
--
--    select/make_new/remove queries UI
--
--    @param: lang
--    @param: name
--
--    reuse the same picker from `create_module`
--

----------------------------
-- LOGIC
----------------------------

-- local function prompt_user_for_input()
--   -- edit_create_from_table(
--   --   create_module.settings.use_telescope,  -> ui type
--   --   t_current_module_names,                -> table
--   --   compare_selection_to_target_table    -> decider function
--   -- )
--   local t_doom_query_paths = user_utils_path.get_doom_queries()
--   if create_module.settings.use_telescope then
--     spawn_telescope_picker_on_table(t_current_module_names, compare_selection_to_target_table)
--   else
--     spawn_nui_input(t_current_module_names, compare_selection_to_target_table)
--   end
-- end

-- -- TODO: get query from file `queries` dir.
-- local function print_query()
--   local bufnr, root, q_parsed_2 = user_ts_utils.get_query(
--     user_ts_utils.get_query_file("lua", "doom_module_packages")
--   )
--   local package_string_nodes = user_ts_utils.get_captures(root, bufnr, q_parsed_2, "package_string")
--   local picker_config = {
--     bufnr = bufnr,
--     entries = {},
--     entries_mapped = {},
--     callback = fork_package,
--   }
--   for k, v in pairs(package_string_nodes) do
--     local nt = tsq.get_node_text(v, bufnr)
--     table.insert(picker_config.entries, nt)
--     picker_config.entries_mapped[nt] = v
--   end
--   fork_plugins_picker_cur_buf(picker_config)
-- end


local function run_doom_queries_ui()
  print("doom queries ui!!!")

  -- > get all queries paths > second level scan `system.doom_root/queries`
  -- > prepare picker object
  -- > create `new/open/rm` callbacks
  -- > query starter template > but in utils/templates.lua
  -- > make telescope mappings (new/open/rm/new_from_fuzzy)

  -- 	picker -> fuzzy/line select name
  -- 	if open -> open()
  -- 	if rm -> kill()
  -- 	if new -> picker -> select lang -> make new under correct lang dir.
end

----------------------------
-- SETTINGS
----------------------------

-- doom_queries.settings = {}

----------------------------
-- PACKAGES
----------------------------

-- doom_queries.packages = {
-- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- -- [""] = {},
-- }

----------------------------
-- CONFIGS
----------------------------

----------------------------
-- CMDS
----------------------------

doom_queries.cmds = {
  {
    "DoomQueriesUI",
    function()
      run_doom_queries_ui()
    end,
  },
}

--------------------------
-- AUTOCMDS
--------------------------

-- doom_queries.autocmds = {}

----------------------------
-- BINDS
----------------------------

doom_queries.binds = {}

----------------------------
-- LEADER BINDS
----------------------------

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(doom_queries.binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "D",

        {
          { "q", [[ :DoomQueriesUI<cr> ]], name = "make/open/rm doom ts queries" },
        },
      },
    },
  })
end

----------------------------
-- RETURN
----------------------------

return doom_queries
