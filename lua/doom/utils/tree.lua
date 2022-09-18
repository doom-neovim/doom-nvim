local tsq = require("vim.treesitter.query")
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- TODO
--
-- ---
-- TODO: RENAME: NODE -> LEAF
-- TODO: PASS ACCUMULATOR TO BRANCH_POST
--
--------------------------------------
-- it would be nice if callbacks only recieve a single table and not mult
-- params so that it looks nicer.
--------------------------------------
-- logger > print each inspect entry on new line \n
--    so that it becomes extra easy to compare
--
--------------------------------------
-- use metatable?
--
--------------------------------------
-- functional chaining
--
-- make it possible to
--
-- local res = crawl(opts).crawl()
--
--------------------------------------
--  entry_counter, leaf_counter, edge_counter.
--
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
--  ARGS | HOW YOU CAN USE CALL `TRAVERSE()`
--
-- print(minimumvalue(8,10,23,12,5))
--
-- print(minimumvalue(1,2,3))
--
--
-- # 0 --------------------------
--
--    crawl default tree > requires setup configuration
--
--
-- # 1 -------------------------------------------------------
--
--    1 table = options
--
--    1 string = filter default
--      load `string` defaults
--
--    1 func = returns options table
--
--
-- # 2 -------------------------------------------------------
--
--      1 table = options,
--      2 table = accumulator
--
--      1 table = opts
--      2 string = filter
--
--      1 table
--      2 function
--
--
-- # 3 -------------------------------------------------------
--
--      acc = crawl(tree, filter, acc)
--
--      1 table = tree
--      2 function|string' =
--      3 table = accumulator
--
--      allows for quickly traversing a tree and flattening out all nodes
--      to a list easilly
--
-- # 4 -------------------------------------------------------
--
--      1 table = tree
--      2 function|string' =
--      3 table = accumulator
--      4
--
-- -----------------------------------------------------------------------------
--
-- _WARNING: if you are using a string filter arg, you have to make sure it is
-- one of the special keywords, or it will be treated as a match string for
-- computing nodes, see XXX.
--
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
--
--  OPTIONS
--
--  ::: option (new name ideas) :::
--
--  ::: tree (required) :::
--
--  ::: max_level :::
--
--  ::: acc :::
--
--  ::: leaf
--
--  ::: branch
--
--  ::: branch_next -> next_subtable (edge_next|subtable) :::
--
--  ::: branch_post
--
--    if there is a specific way that you access the next entry to analyze
--    within RHS if rhs == table
--
--
--  ::: filter (filter/separator/determine_node) :::
--
--      callback determine if tree entry is node or branch
--
--      FUNCTION
--
--      TABLE
--
--      STRING
--        special keyword  := string|list
--
--  ::: filter_ids -> node_ids (filter_props|node_ids|filter_ids) :::
--
--      IS THIS A SPECIAL CASE OF `FILTER` BELOW WHERE THE TYPE(ARG) == "TABLE"???.
--      THIS WOULD SIMPLIFY THINGS QUITE A LOT...
--
--      table array containing predefined properties that you know identifies a leaf.
--      Eg. doom module parts. See `core/spec.module_parts`
--      pass a list of specific attributes that you know constitutes a leaf node
--      and filter on this
--
-- -- callback function used to identify a leaf
-- --
-- -- special keywords: (string, list)
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--
-- WIP: TREE LOG/DEBUG HELPER
--

-- At the moment (1) below is probably the most reliable.
-- The goal is to make `large_pretty` for debugging large trees with colors n stuff.
--
-- i. within count range. always keep a count and only print nodes [x - y]
-- ii. levels range
-- iii. print colors
--
-- eg.
-- log = {
--   use = true,
--   mult = 8,
--   name_string = "test list modules",
--   cat = 1,
--   inspect = true,
--   new_line = true,
--   frame = true,
--   separate = true,
-- },

-- 1 = log all
-- 2 = log only branch and leaf
-- 3 = only leaves
-- 4 = only branches
-- 5 = only edge data
--
-- ::: LOGGING DEFAULTS :::
--
-- nodes
-- edge
-- mini | minimal
-- all | both | base | default
-- full | inspect
-- pretty
-- large_pretty: large prints where each entry is printed with a nice frame and colors so that
--    you can truly see what is happening.
--    Or open up a split that writes this as a temporary file with highlights and everything so that you can truly debug easilly.
--
--
--  create a frame around the tree so that you can make very descriptive logs on large screens
--

local function compute_indentation(stack, sep, mult)
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

local function logger(is_node, opts, stack, k, v)
  -- use table pattern to make the messages more variable and dynamic.
  --
  -- NOTE: FRAME -> LOOK AT HOW VENN.NVIM IS WRITTEN

  local msg = { entry = {}, rhs = { data = "", state = "" } }

  if not opts.log.use then
    return
  end

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

    if opts.log.inspect then
      print(pre .. " rd: " .. msg.rhs.data)
    end
    print(pre .. " rs: " .. msg.rhs.state)
  end

  if opts.log.separate then
    print("\n")
  end
end

local M = {}

--
-- A COUPLE OF HELPER FUNCTIONS THAT SHOULD BE CONSIDERED MOVAL INTO SOME OTHER LOCATION MAYBE.
--

--- conatenate path stack with node
--- rename: flatten_stack is a non descriptive name -> concat_node_path()
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

-- Helper for attaching data to a specific table path in `head` table. Eg. `doom.modules`
-- could be a head if you want to append all modules upon loading doom.
--
-- TODO: rename > get_set_table_path()
--
-- if no data supplies -> returns table path node
--
-- @param table list of path components
M.attach_table_path = function(head, tp, data)
  if not head then
    return false
  end
  local last = #tp
  for i, p in ipairs(tp) do
    if i ~= last then
      if head[p] == nil then
        if not data then
          -- if a nil occurs, this means the path does no exist >> return
          return false
        end
        head[p] = {}
      end
      head = head[p]
    else
      if data then
        if type(data) == "function" then
          data(head[p])
        else
          head[p] = data
        end
      else
        return head[p]
      end
    end
  end
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

-- compute state of left and right hand sides of the key value pair for each table entry.
-- so that one can specify which `leaf` nodes one likes to process.
-- This is determined in the `filter` option.
-- opts.filter determines which nodes will be processed in the `opts.leaf` callback.
-- all others are passed to the `opts.branch` callbacks

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

-- todos: vars that would allow more fine grained control
--  - move recurse into traversal.
--  - add counters that keep track of all kinds of relevan data for a table
--  - increment `counter_leaf`
--  - increment `counter_branch`
--  - increment `counter_entry`
--  - assert tree == table or return and run logger on the previous entry
--
--  - treesitter TSNode compatible
--
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
      -- branch pre
      local pre = opts.branch(stack, k, v)
      if pre then
        table.insert(accumulator, pre)
      end
      table.insert(stack, k)
      -- recurse down
      local p
      accumulator, p = M.recurse(opts, opts.branch_next(v), stack, accumulator)

      -- BRANCH POST (wip)
      --
      -- not really used apart from in `queries/utils` which attempts
      -- to converst a table into a ts query syntax string.
      --
      -- allows you to enclose the branch conditionally based on data bubbling
      -- up from child branches/leaves
      -- TODO: test pass accumulator to branch_post
      local post = opts.branch_post(stack, k, v, p)
      if post then
        table.insert(accumulator, post)
      end
    else
      -- leaf
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
-- does it make sense to split up the recurse func into smaller components
-- or keep as one unit?
--

-- M.process_branch = function(opts, k, v, stack, accumulator)
--   opts.branch(stack, k, v)
--   -- table.insert(accumulator, ret)
--   table.insert(stack, k)
--
--   -- TODO: need to be able to determine which prop to recurse down!!!
--   --
--   -- a. select which prop to recurse down.
--   -- b. should this be the same table as the one we return?
--
--   -- M.recurse(opts, v, stack, accumulator)
--   M.recurse(opts, opts.branch_next(v), stack, accumulator)
--
--   return stack, accumulator
-- end
-- M.process_leaf = function(opts, k, v, stack, accumulator)
--   local ret = opts.node(stack, k, v)
--   table.insert(accumulator, ret)
--   return stack, accumulator
-- end

--
-- RECURSE TREESITTER VERSION --
--

-- wip / unused
--
-- Currently this is a treesitter func that parses a leader tree
-- recursively via TSNodes.
--
-- It expects the first `table_constructor` field within the
-- <leader> table.
--
-- should we keep this as stand alone. or merge this into
-- recurse so that the `recurse` function becomes treesitter
-- compatible, which would be quite based
--
-- This would mean generalizing `recurse_ts` ingo `recurse` above.
--
-- This would be necessary (and a useful exercise) in order to be able
-- to access disabled modules since those aren't loaded, or require
-- all modules upon calling `dui`, however, in that case, we could
-- use the exact same tree recurse call in both `core/config` and
-- insed of `mod/utils.extend()`
--
-- this would also give us flexibility in the future. knowing that we
-- have utils to easilly scan modules with ts.
--
-- nvim-treesitter has some recursive utils as well. check em out.
--
M.recurse_ts = function(buf, node, accumulated, level)
  -- note: is level even used? should use the same stack pattern?
  if accumulated == nil then
    accumulated = {
      level = 0,
    }
  else
    accumulated.level = level + 1
  end
  accumulated["container"] = node
  -- print(level, "--------------------------------------------")
  if node:type() == nil or node:type() ~= "table_constructor" then
    return false
  end
  -- FIX: put in state table
  local cnt = 1 -- child counter
  local special_cnt = 0
  local second_table
  local second_table_idx
  local second_table_cnt = 0
  local rhs
  local name_found
  local mode_found
  local opts_found
  local desc_found
  -- FIX: redo with iter_named_children()
  for n in node:iter_children() do
    if n:named() then
      local the_node = n:named_child(0) -- table constructor
      local the_type = the_node:type(0)
      if cnt == 1 then
        if the_type == "table_constructor" then
          -- accumulated["children"] = {}
          local child_table = {
            doom_category = "binds_table",
          }
          for child in node:iter_children() do
            if child:named() then
              if child:type() == "field" then
                table.insert(
                  child_table,
                  M.parse_nest_tables_meta_data(buf, child:named_child(0), {}, accumulated.level)
                )
              end
            end
          end
          table.insert(accumulated, child_table)
          return accumulated
        else
          accumulated["prefix"] = the_node
          accumulated["doom_category"] = "binds_leaf"
          local nt = tsq.get_node_text(the_node, buf)
          accumulated["prefix_text"] = nt

          special_cnt = special_cnt + 1
        end
      end
      if cnt ~= 1 then
        if the_type == "table_constructor" then
          second_table = the_node
          second_table_idx = special_cnt
          second_table_cnt = second_table_cnt + 1
        end
      end
      if
        cnt == 2
        and (
          the_type == "string"
          or the_type == "function_definition"
          or the_type == "dot_index_expression"
        )
      then
        rhs = the_node
      end
      local c2 = n:named_child(0)
      if c2:type() == "identifier" then
        local nt = tsq.get_node_text(c2, buf)
        if nt == "name" then
          accumulated["name"] = c2
          name_found = true
          special_cnt = special_cnt + 1
        elseif nt == "mode" then
          accumulated["mode"] = c2
          mode_found = true
          special_cnt = special_cnt + 1
        elseif nt == "description" then
          accumulated["description"] = c2
          desc_found = true
          special_cnt = special_cnt + 1
        elseif nt == "options" then
          accumulated["options"] = c2
          opts_found = true
          special_cnt = special_cnt + 1
        else
          rhs = the_node
        end
      end
      cnt = cnt + 1
    end
  end
  if accumulated.name == nil and special_cnt >= 3 then
    accumulated["name"] = node:named_child(2)
  end
  if accumulated.description == nil and special_cnt >= 4 then
    accumulated["description"] = node:named_child(3)
  end
  if accumulated.rhs == nil and second_table then
    rhs = second_table
    accumulated["doom_category"] = "binds_branch"
  end
  accumulated["rhs"] = rhs
  if accumulated.rhs:type() == "table_constructor" then
    accumulated["rhs"] = M.parse_nest_tables_meta_data(buf, accumulated.rhs, {}, level)
  end
  return accumulated
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

--
-- TREE ENTRY POINT -------
--

-- TODO: PUT ALL THESE SETUP STATEMENTS IN A METATABLE??
--
--  i am not used to meta tables yet

-- TODO: USE ... TO MANAGE VARIABLE ARGS
--
-- ARGS SYNTAX EXAMPLE
--
-- function minimumvalue (...)
--    local mi = 1 -- maximum index
--    local m = 100 -- maximum value
--    local args = {...}
--    for i,val in ipairs(args) do
--       if val < m then
--          mi = i
--          m = val
--       end
--    end
--    return m, mi
-- end
M.traverse_table = function(opts, tree, acc)
  opts = opts or {}
  tree = opts.tree or tree
  if not opts.log then
    opts.log = {}
  end

  --
  -- HANDLE DEFAULTS AND NILS
  --

  -- TREE -----------------------------------------------------------------------------
  --
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

  -- OPTS.MAX_LEVEL -----------------------------------------------------------------------------

  opts.max_level = opts.max_level or 10

  -- ACCUMULATOR -----------------------------------------------------------------------------
  --
  ---     if you want to continue accumulating to an already existing list, then pass this
  ---     option.
  if opts.acc then
    acc = opts.acc or acc
    -- remove acc prop
  end

  -- LEAF DEFAULT CALLBACK -----------------------------------------------------------------------------
  --
  ---     how to process each node node
  ---     return appens to accumulator
  if not opts.leaf then
    opts.leaf = function(_, _, v)
      return v
    end
  end

  -- BRANCH DEFAULT CALLBACK -----------------------------------------------------------------------------
  --
  ---     how to process each branch node
  ---       return appens to accumulator
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

  -- LEAF IDS -----------------------------------------------------------------------------
  --
  --      table array containing predefined properties that you know identifies a node.
  --      Eg. doom module parts. See `core/spec.module_parts`
  --
  -- pass a list of specific attributes that you know constitutes a node node
  -- and filter on this
  opts.filter_ids = opts.filter_ids or false

  -- OPTS.EDGE -----------------------------------------------------------------------------
  --
  -- callback function used to identify a node
  --
  -- special keywords: (string, list)
  --
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

  -- default case if you leave filter empty.
  if not opts.filter then
    opts.filter = function(_, _, r)
      return not r.is_tbl
    end
  end

  --
  -- RECURSE MAIN FUNC
  --

  -- MOVE RECURSE TO HERE...

  --
  -- MAIN CALL
  --

  if opts.log.frame then
    print("[---------" .. opts.log.name_string .. "---------]")
  end

  acc = M.recurse(opts, tree, {}, acc)

  if opts.log.frame then
    print("[------------------------------------------------]")
  end

  return acc
end

return M
