local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")

-- TREESITTER
local tsq = require("vim.treesitter.query")
local parsers = require "nvim-treesitter.parsers"

local M = {}


local ROOT_MODULES = utils.find_config("modules.lua")

M.ntext = function(n,b) return tsq.get_node_text(n, b) end

-- system.sep!!! -> util?
M.get_query_file = function(lang, query_name)
  return fs.read_file(string.format("%s/queries/%s/%s.scm", system.doom_root, lang, query_name))
end

M.ts_get_doom_captures = function(buf, doom_capture_name)
  local t_matched_captures = {}
  local query_str = M.get_query_file("lua", "doom_conf_ui")
  local language_tree = vim.treesitter.get_parser(buf, "lua")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local qp = vim.treesitter.parse_query("lua", query_str)

  for id, node, _ in qp:iter_captures(root, buf, root:start(), root:end_()) do
    local name = qp.captures[id]
	  if name == doom_capture_name then
        table.insert(t_matched_captures, node)
	  end
   end
   return t_matched_captures
end
-- I BELIEVE THAT THIS FUNCTION ALSO EXPECTS THE (TABLE_CONSTRUCTOR) NODE
-- AS INPUT.
M.transform_root_mod_file = function(m, cb)

  local buf = utils.get_buf_handle(ROOT_MODULES)

  local query_str = doom_ui.get_query_file("lua", "doom_root_modules")
  local language_tree = vim.treesitter.get_parser(buf, "lua")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local qp = vim.treesitter.parse_query("lua", query_str)

  local sm_ll = 0 -- section module last line

  if qp ~= nil then
    for id, node, metadata in qp:iter_captures(root, buf, root:start(), root:end_()) do
      local cname = qp.captures[id] -- name of the capture in the query
      local node_text = ntext(node, buf)
      -- local p = node:parent()
      local ps = (node:parent()):prev_sibling()
      if ps ~= nil then
        local pss = ps:prev_sibling()
        if pss ~= nil then
          local section_text = ntext(pss, buf)
          if m.section == section_text then
            sm_ll, _, _, _ = node:range()
            if cb ~= nil then
              cb(buf, node, cname, node_text)
            end
          end
        end
      end
    end
  end
  -- vim.api.nvim_win_set_buf(0, buf)
  return buf, sm_ll + 1
end

M.gen_query_for_selection = function()
  -- helper to allow for using the already existing doom table instead of having to
  -- parse eg. the nest tree before initiating pickers.
  -- on selection -> generate a query that targets the selection.
  -- --> apply code actions.
end

return M
