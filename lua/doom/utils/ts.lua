local log = require("doom.utils.logging")
local utils = require("doom.utils")
local tsq = require("vim.treesitter.query")

local ts = {}

ts.get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "lua", {})
  local tree = parser:parse()[1]
  return tree:root()
end

-- TODO: allow chained scopes
--
--    >>> use varargs [ qN, cN ... ]
ts.get_captures = function(path, q1, c1, q2, c2)
  local path = path or utils.find_config("modules.lua")
  local buf = utils.get_buf_handle(path)
  local root = ts.get_root(buf)
  local t1 = {}
  local t2 = {}

  print("Q1:", q1, "\n", "Q2:", q2)

  local return_both = q2 and c2

  -- NOTE: this prints long after I am expecting it to print??!

  if q2 and c2 then
    local parsed1 = vim.treesitter.parse_query("lua", q1)
    for id, node, _ in parsed1:iter_captures(root, buf, 0, -1) do
      local name = parsed1.captures[id]
      if name == c1 then
        table.insert(t1, {
          node = node,
          text = tsq.get_node_text(node, buf),
          range = { node:range() },
        })
      end
    end
  else
    q2 = q1
    c2 = c1
  end

  local parsed2 = vim.treesitter.parse_query("lua", q2)
  for id, node, _ in parsed2:iter_captures(root, buf, 0, -1) do
    local name = parsed2.captures[id]
    if name == c2 then
      table.insert(t2, {
        node = node,
        text = tsq.get_node_text(node, buf),
        range = { node:range() },
      })
    end
  end

  if return_both then
    print("TS both")
    -- if both queries are supplied
    return t1, t2, buf
  else
    print("TS single")
    return t2, buf
  end
end

ts.parent_n = function(tsnode, n)
  local child = tsnode
  local parent
  local n = n or 1

  for i = 1, n do
    parent = child:parent()
    print("get_parent_n:", i, child:type(), parent:type())
    child = parent
  end

  return parent
end

ts.child_n = function(tsnode, child_path)
  local current = tsnode
  local child

  for _, v in ipairs(child_path) do
    child = current:named_child(v)
    if not child then
      return false
    end
    current = child
  end
  return child
end

return ts
