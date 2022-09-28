---
-- MIT License
--
-- Copyright (c) 2022 Hjalmar Jakobsson
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local M = {}

--
-- TREE LOG/DEBUG HELPER
--

--- Tree logger options
---
---  @class LoggerOptions
---  @use           bool
---  @mult          int
---  @name_string   string
---  @cat           int<1,5>
---  @inspect       bool
---  @new_line      bool
---  @frame         bool
---  @separate      bool

-- TODO: clean up

local function logger(is_node, opts, stack, k, v)
  if not opts.log.use then
    return
  end
  local function compute_indentation(stack, sep, mult)
    -- TODO: better var names
    local a = ""
    local b = ""
    mult = mult or 1
    for _ = 1, #stack do
      a = a .. sep
    end
    for _ = 1, mult do
      b = b .. a
    end
    return b
  end

  -- use table pattern to make the messages more variable and dynamic.
  --
  -- NOTE: FRAME -> LOOK AT HOW VENN.NVIM IS WRITTEN

  local msg = { entry = {}, rhs = { data = "", state = "" } }

  local iters = opts.log.iters or (#stack + 1)
  if #stack + 1 ~= iters then
    return
  end

  local cat = opts.log.cat or 2

  -- use these to compute a frame for the tree.
  local num_col = 0
  local num_lines = 0

  local all = cat == 1
  local full = cat == 2
  local ind = compute_indentation(stack, " ", opts.log.mult)
  local edge_shift = "      "
  local pre = edge_shift .. ind
  local points_to = " : "

  local post_sep = opts.log.new_line and ("\n     " .. pre) or " / "

  -- local ind_str = "+" and is_node or "-"

  -- todo: LEAF / BRANCH merge into one statement!!!
  if is_node and (all or full or cat == 3) then
    msg.entry = string.format(
      [[%s %s > (%s) %s %s]],
      "+",
      compute_indentation(stack, "+", opts.log.mult),
      #stack,
      k.val,
      v.val
    )
  end

  if not is_node and (all or full or cat == 4) then
    msg.entry = string.format(
      [[%s %s > (%s) %s %s]],
      "-",
      compute_indentation(stack, "-", opts.log.mult),
      #stack,
      k.val,
      v.val
    )
  end

  print(msg.entry)
  ------------------------------------

  if all or cat == 5 then
    msg.lhs = { data = "", state = "" }
    for key, value in pairs(k) do
      if key ~= "val" then
        msg.lhs.state = msg.lhs.state .. tostring(key) .. points_to .. tostring(value) .. post_sep
      else
        msg.lhs.data = msg.lhs.data .. type(value) .. points_to .. value
      end
    end
    if opts.log.inspect then
      print(pre .. " ld: " .. msg.lhs.data)
    end
    print(pre .. " ls: " .. msg.lhs.state)

    msg.rhs = { data = "", state = "" }
    for key, value in pairs(v) do
      if key ~= "val" then
        msg.rhs.state = msg.rhs.state .. tostring(key) .. points_to .. tostring(value) .. post_sep
      else
        if type(v.val) == "table" then
          for i, j in pairs(value) do
            msg.rhs.data = msg.rhs.data .. i .. points_to .. tostring(j) .. post_sep
          end
        else
          msg.rhs.data = msg.rhs.data .. type(value) .. points_to .. tostring(value)
        end
      end
    end

    -- FIX: rd and sd are very bad undescriptive names
    if opts.log.inspect then
      print(pre .. " rd: " .. msg.rhs.data)
    end
    print(pre .. " rs: " .. msg.rhs.state)
  end

  if opts.log.separate then
    print("\n")
  end
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--- Conatenate path stack with node / Only used inside of tree..
--
--- RENAME: flatten_stack is a non descriptive name -> concat_table_path()
---
---@param stack   table Internal stack
---@param v       any
---@param concat  string String; returns concatenatd string as second ret val.
M.flatten_stack = function(stack, v, concat)
  local pc = { v }
  if #stack > 0 then
    pc = vim.deepcopy(stack)
    table.insert(pc, v)
  end
  if concat then
    return pc, table.concat(pc, concat)
  else
    return pc
  end
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- NOTE: If I move these state funcs inside of the `recurse` func, will this re-instatiate the funcions for each recursive loop?? If not, then it makes sense to move them inside.

-- Compute state of left and right hand sides of the key value pair for each
-- table entry - so that one can specify which `leaf` nodes one likes to
-- process. This is determined in the `filter` option. opts.filter determines
-- which nodes will be processed in the `opts.leaf` callback. all others are
-- passed to the `opts.branch` callbacks

local function check_lhs(l)
  return {
    val = l,
    is_num = type(l) == "number",
    is_str = type(l) == "string",
  }
end

local function check_rhs(r, opts)
  local ret = {
    val = r,
    is_fun = type(r) == "function",
    is_tbl = type(r) == "table",
    is_str = type(r) == "string",
    is_num = type(r) == "number",
    str_empty = r == "",
    id_match = false,
    numeric_keys = false,
    num_keys = nil,
  }
  if ret.is_tbl then
    local num_keys = 0
    for k, _ in pairs(r) do
      num_keys = num_keys + 1
      if opts.filter_ids then
        ret.id_match = vim.tbl_contains(opts.filter_ids, k) and true or false
      end
      ret.numeric_keys = type(k) == "number" -- FIX: becomes false for non numbers even if one number exists..
    end
    ret.num_keys = num_keys
    ret.tbl_empty = num_keys == 0
  end
  return ret
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- Main recursive function

-- TODO: should I redo this function with a single opts table, that also holds
-- vars so that I can minimize the number of parameters passed around?
-- It would be nice to only use a single `opts` table and then keep all
-- data inside of it.

M.recurse = function(opts, tree, stack, accumulator)
  accumulator = accumulator or {}
  stack = stack or {}
  local pass_up = {}

  for k, v in pairs(tree) do
    local left = check_lhs(k)
    local right = check_rhs(v, opts)
    local is_node = opts.filter(opts, left, right)

    logger(is_node, opts, stack, left, right)

    if not is_node then
      -- BRANCH PRE
      local pre = opts.branch(stack, k, v)
      if pre then
        table.insert(accumulator, pre)
      end
      table.insert(stack, k)
      -- recurse down
      local p

      -- recurse down
      accumulator, p = M.recurse(opts, opts.branch_next(v), stack, accumulator)

      -- BRANCH POST (wip)
      --
      -- not really used apart from in `queries/utils` which attempts
      -- to convert a table into a ts query syntax string.
      --
      -- allows you to enclose the branch conditionally based on data bubbling
      -- up from child branches/leaves. This is not fully working/teste at the moment
      -- TODO: test pass accumulator to branch_post
      local post = opts.branch_post(stack, k, v, p)
      if post then
        table.insert(accumulator, post)
      end

    else
      -- LEAF
      local ret = opts.leaf(stack, k, v)
      if ret then
        if ret.pass_up then
          table.insert(pass_up, ret.pass_up)
        else
          table.insert(accumulator, ret)
        end
      end
    end
  end
  table.remove(stack, #stack)
  -- print("XX:", vim.inspect(pass_up))
  return accumulator, pass_up
end

--
-- TREE ENTRY POINT
--

--- Tree traversal options
--- @class  Tree traversal options
--- @field  tree         table|func       (required) table you wish to traverse. If function then the return value is used.
--- @field  max_level    int|nil          prevent traversing a table that is too large
--- @field  acc          table|nil        You can pass an existing accumulator array to which the leaf callback return is appended.
--- @field  leaf         func|string|nil  The return value is appended to the accumulator array
--- @field  branch       func|nil
--- @field  branch_post  func|nil
--- @field  branch_next  func|nil         Allows you to specify an expected subtable to recurse into -         An example of this is in `dui` where I traverse each modules binds table.
--- @field  branch_post  func|nil
--- @field  filter       func|list|string|nil   Callback determine if tree entry is node or branch. There is a set of special string keywords that you can pass to filter that are often recuring patterns that you want to recurse, eg. `settigs` table or perform a regular loop over a table.
--- @field  filter_ids   table|nil    Table array containing predefined properties that you know identifies a node. Eg. doom module parts. See `core/spec.module_parts`. iirc filter == table (ie. rhs = table), then you can specify a set of subkeys that together would identify as a leaf node.
--- @field    table       See logger func.

M.traverse_table = function(opts)
  opts = opts or {}
  local tree = opts.tree or tree

  if not opts.log then
    opts.log = {}
  end

  -- Add sensible defaults

  if not tree then
    -- assert tree here to make sure it is passed.
    print("TREE ERROR > tree is required")
  end

  if type(tree) == "table" and #tree == 0 then
    -- return
  end

  if type(tree) == "function" then
    tree = tree()
  end

  opts.max_level = opts.max_level or 10

  if opts.acc then
    acc = opts.acc or acc
    -- remove acc prop
  end

  if not opts.leaf then
    opts.leaf = function(_, _, v)
      return v
    end
  end

  if not opts.branch then
    opts.branch = function()
      return false
    end
  end

  if not opts.branch_post then
    opts.branch_post = function()
      return false
    end
  end

  -- determines how to access the next entry that should be analyzed for edge/node
  if not opts.branch_next then
    opts.branch_next = function(v)
      return v
    end
  end

  opts.filter_ids = opts.filter_ids or false

  if type(opts.filter) == "string" then
    if opts.filter == "list" then
      opts.filter = function()
        return true
      end
    elseif opts.filter == "settings" then
      opts.filter = function(_, l, r)
        return l.is_num or not r.is_tbl or r.numeric_keys or r.tbl_empty
      end
    else
      local flt_str = opts.filter
      opts.filter = function(_, _, r)
        return r.val.type == flt_str
      end
    end
  end

  if not opts.filter then
    opts.filter = function(_, _, r)
      return not r.is_tbl
    end
  end

  -- returns the accumulator
  return M.recurse(opts, tree, {}, acc)
end

return M
