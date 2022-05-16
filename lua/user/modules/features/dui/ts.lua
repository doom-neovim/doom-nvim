-- -- TREESITTER
-- local tsq = require("vim.treesitter.query")
-- local parsers = require "nvim-treesitter.parsers"

local ROOT_MODULES = utils.find_config("modules.lua")

local function ntext(n,b) return tsq.get_node_text(n, b) end

-- I BELIEVE THAT THIS FUNCTION ALSO EXPECTS THE (TABLE_CONSTRUCTOR) NODE
-- AS INPUT.
local function transform_root_mod_file(m, cb)

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
