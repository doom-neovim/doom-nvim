local ts_jump_to_module_part = {}

-- TODO:
--
--    -

ts_jump_to_module_part.settings = {}

ts_jump_to_module_part.packages = {
  [""] = {},
  -- [""] = {},
  -- [""] = {},
  -- [""] = {},
}

local query_str = [[
; Scopes

; [
;   (chunk)
;   (do_statement)
;   (while_statement)
;   (repeat_statement)
;   (if_statement)
;   (for_statement)
;   (function_declaration)
;   (function_definition)
; ] @scope

; Definitions

(assignment_statement
  (variable_list
    (identifier) @definition.var))

(assignment_statement
  (variable_list
    (dot_index_expression . (_) @definition.associated (identifier) @definition.var)))

; (function_declaration
;   name: (identifier) @definition.function)
;   (#set! definition.function.scope "parent")
;
; (function_declaration
;   name: (dot_index_expression
;     . (_) @definition.associated (identifier) @definition.function))
;   (#set! definition.method.scope "parent")
;
; (function_declaration
;   name: (method_index_expression
;     . (_) @definition.associated (identifier) @definition.method))
;   (#set! definition.method.scope "parent")
;
; (for_generic_clause
;   (variable_list
;     (identifier) @definition.var))
;
; (for_numeric_clause
;   name: (identifier) @definition.var)
;
; (parameters (identifier) @definition.parameter)

; References

; [
;   (identifier)
; ] @reference

]]

local function get_query(query_name)
  local language_tree = vim.treesitter.get_parser(0)
  local syntax_tree = language_tree:parse()

  local root = syntax_tree[1]:root()
  local sep = "\n"

  local matches = {}

  -- opts.ft
  -- opts.query
  local the_lang = query_lang or vim.bo.filetype

  local ok, result = pcall(vim.treesitter.parse_query, the_lang, query_name)

  -- {
  --   captures = <1>{ "scope", "definition.var", "definition.associated", "reference" },
  --   info = {
  --     captures = <table 1>,
  --     patterns = {}
  --   },
  --   query = <userdata 1>,
  --   <metatable> = <2>{
  --     __index = <table 2>,
  --     apply_directives = <function 1>,
  --     iter_captures = <function 2>,
  --     iter_matches = <function 3>,
  --     match_preds = <function 4>
  --   }
  -- }
  if ok then
    -- -- iter capt
    -- for id, node, metadata in result:iter_captures(root, references.target_bufnr) do
    --   local name = result.captures[id] -- name of the capture in the query
    --
    --   -- typically useful info about the node:
    --   local type = node:type() -- type of the captured node
    --   local row1, col1, row2, col2 = node:range() -- range of the capture
    --
    --   local nt = q.get_node_text(node, references.target_bufnr)
    --   -- ts_utils.get_node_text(node)
    --
    --   print(">>>", name, type, nt)
    -- end

    -- table.insert(matches, result)
    -- iter match
    for pattern, match, metadata in result:iter_matches(root, references.target_bufnr) do
      -- i(pattern)
      for id, node in pairs(match) do
        local name = result.captures[id]
        local nt = q.get_node_text(node, references.target_bufnr)
        -- `node` was captured by the `name` capture in the match
        local node_data = metadata[id] -- Node level metadata
        print("MATCH, capt: ", name, "nt:", nt)
      end
      table.insert(matches, captures)
    end
    return matches
    -- return table.concat(matches, sep)
  else
    return result
  end
end

local jump_names_list = {
  "settings",
  "packages",
  "cmds",
  "autocmds",
  "binds",
}

-- test parse the packages table and make auto fork command.
local function jump_to(s)
  for i, v in pairs(jump_names_list) do
    if s == v then
      print("> ", v)

    end
  end
end

ts_jump_to_module_part.cmds = {
  {
    "TSJumpToSettings",
    function()
      jump_to("packages")
    end,
  },
  -- { "TSJumpToPackages" },
}
ts_jump_to_module_part.autocmds = {}
ts_jump_to_module_part.binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(ts_jump_to_module_part.binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "YYY",
        name = "+ZZZ",
        {
          -- first level
        },
      },
    },
  })
end

return ts_jump_to_module_part
