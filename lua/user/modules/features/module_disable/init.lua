local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local tsq = require("vim.treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local locals = require("nvim-treesitter.locals")
local api = vim.api
local cmd = api.nvim_command
-- local doom_queries = require("user.utils.doom_queries")
local user_ts_utils = require("user.utils.ts")

local modules_disable = {}

-- TODO:
--
--
--      -. TEST WITH DUMMY BUF FOR NOW.
--      -. print all mods per section.
--      -. toggle.
--      -. open buf in split. > inspect results.
--      -. uri_to_bufnr > when everything works
--
--
--
--

-- local function filter_modules_by_cat(source, nodes, cat)
--   local res = {}
--   for _, n in pairs(nodes) do
--     local t = tsq.get_node_text(n, source)
--     print(cat)
--     if cat == "modules.enabled" and t ~= nil then
--       local p = n:parent()
--       local pp = p:parent()
--       local ppp = pp:parent()
--       local nt = tsq.get_node_text(ppp, source)
--       print(ppp:type())
--       -- local pps = p:prev_named_sibling()
--       -- local mcat = pps:prev_named_sibling() -- this gets the parent category name
--       -- local nt = tsq.get_node_text(pps, source)
--       -- print(nt)
--       --     if nt == cat then
--       --       table.insert(res, n)
--       --     end
--     elseif cat == "modules.disabled" then
--     end
--   end
--   return res
-- end

local function load_with_file(path)
  local buf_tmp = vim.api.nvim_create_buf(true, true)
  local fd = fs.read_file(path)
  vim.api.nvim_buf_set_text(buf_tmp, 0, 0, 0, 0, vim.split(fd, "\n"))
  return buf_tmp
end

local function modules_toggle_section(opts)
  local toggle_state = opts.enabled and "enabled" or "disabled"

  -- replace with `vim.uri_to_bufnr`
  local settings_path = utils.find_config("modules.lua") -- returns full path..
  local buf = load_with_file(settings_path)

  -- TODO:
  -- iterate captures and collect nodes
  --
  -- - `all` or `mname`
  --
  --
  --
  local collected_nodes = {}
  local buf, root, qp = user_ts_utils.run_query_on_buf("lua", "doom_root_modules", buf)
  if qp ~= nil then
    for id, node, metadata in qp:iter_captures(root, buf, root:start(), root:end_()) do
      local name = qp.captures[id] -- name of the capture in the query
      local node_text = tsq.get_node_text(node, buf)
      local p = node:parent()
      local ps = p:prev_sibling()
      if ps ~= nil then -- sometimes is nil, dunno why..
        local pss = ps:prev_sibling()
        if pss ~= nil then
          local section_text = tsq.get_node_text(pss, buf)

          if opts.enabled and opts.section_name == section_text and name == "modules.enabled" then
            print("ON -> ", section_text, ">", node_text)
            local sr, sc, er, ec = node:range()
            -- :A/((identifier) @wrapit (#eq? @wrapit "foo"))/wrapit:-- @wrapit/
            api.nvim_buf_set_text(buf, sr, sc, er, ec, { "-- " .. node_text })

            -- if all ->
            -- if single ->

          elseif
            not opts.enabled
            and opts.section_name == section_text
            and name == "modules.disabled"
          then
            print("OFF -> ", section_text, ">", node_text)
            local sr, sc, er, ec = node:range()
            api.nvim_buf_set_text(buf, sr, sc, er, ec, { node_text:sub(4) })


          end
        end
      end
    end
  end

  -- vim.api.nvim_buf_delete(buf, { force = true, unload = true })
  vim.api.nvim_win_set_buf(0, buf)
end

local function modules_user_disable_all()
  modules_toggle_section({ section_name = "user", enabled = true })
end

local function modules_user_enable_all()
  modules_toggle_section({ section_name = "user", enabled = false })
end

local function disable_select() end

----------------------------
-- SETTINGS
----------------------------

modules_disable.settings = {}

----------------------------
-- PACKAGES
----------------------------

-- modules_disable.packages = {
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

-- disable_all_modules("features/langs/user")
modules_disable.cmds = {
  {
    "DoomModulesDisableAll",
    function()
      modules_user_disable_all()
    end,
  },
  {
    "DoomModulesEnableAll",
    function()
      modules_user_enable_all()
    end,
  },
}

--------------------------
-- AUTOCMDS
--------------------------

-- modules_disable.autocmds = {}

----------------------------
-- BINDS
----------------------------

modules_disable.binds = {
  {
    "<leader>",
    name = "+prefix",
    {
      {
        "D",
        name = "+doom",
        {
          {
            "M",
            name = "+modules",
            {
              { "P", ":DoomModulesDisableAll<cr>", name = "disable all modules" },
              { "p", ":DoomModulesEnableAll<cr>", name = "disable all modules" },
            },
          },
        },
      },
    },
    -- lvl 1 branch
  },
}

----------------------------
-- RETURN
----------------------------

return modules_disable
