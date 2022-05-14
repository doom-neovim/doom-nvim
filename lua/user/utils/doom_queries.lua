local utils = require("doom.utils")
local fs = require("doom.utils.fs")
local system = require("doom.core.system")

local function doom_get_query_by_name(lang, query_name)
  local query_path = string.format("%s/queries/%s/%s.scm", system.doom_root, lang, query_name)
  return fs.read_file(query_path)
end

local test_table = {}

-- TODO: add mult lang syntax highlighting
-- 	apply scheme to [[ ... ]] queries

test_table.packages = {
  "first/tttt_ss-st.nvim",
  ["first.aaa"] = { "second/t_e-rrr.aaa" },
  ["first"] = { "second/xxx", opt = true },
  ["firstX"] = { "second/rst.nnnnn", opt = true, arst = "arst" },
}
-- assignment_statement [6, 0] - [11, 1]
--   variable_list [6, 0] - [6, 19]
--     name: dot_index_expression [6, 0] - [6, 19]
--       table: identifier [6, 0] - [6, 10]
--       field: identifier [6, 11] - [6, 19]
--   expression_list [6, 22] - [11, 1]
--     value: table_constructor [6, 22] - [11, 1]
--       field [7, 2] - [7, 25]
--         value: string [7, 2] - [7, 25]
--       field [8, 2] - [8, 42]
--         name: string [8, 3] - [8, 14]
--         value: table_constructor [8, 18] - [8, 42]
--           field [8, 20] - [8, 40]
--             value: string [8, 20] - [8, 40]
--       field [9, 2] - [9, 42]
--         name: string [9, 3] - [9, 10]
--         value: table_constructor [9, 14] - [9, 42]
--         ...
-- (
--   (pair
--     key: (property_identifier) @key-name
--     value: (identifier) @value-name)
--   (#eq? @key-name @value-name)
-- )
-- (variable_list
--   (dot_index_expression . (_) @definition.associated (identifier) @definition.var))
local doom_queries = {
  doom_get_package_repo_fields = [[

  (assignment_statement
    (variable_list
      (dot_index_expression . (_) @definition.associated (identifier) @definition.var)) @varl

    (expression_list (table_constructor [
        (field value: (string) @package_string)
        (field value: (table_constructor (field value: (string) @package_string )))
      ]))


  (#eq? @definition.var "packages")
  )

  ;(assignment_statement
  ;(expression_list (table_constructor [
  ;  (field value: (string) @package_string)
  ;  (field value: (table_constructor (field value: (string) @package_string )))
  ;])))

  ]],
  lua_scopes = [[
[
  (chunk)
  (do_statement)
  (while_statement)
  (repeat_statement)
  (if_statement)
  (for_statement)
  (function_declaration)
  (function_definition)
] @scope
]],
  lua_assignment_identifier = [[
(assignment_statement
 (variable_list
   (identifier) @definition.var))
]],
  lua_assignment_dot = [[
(assignment_statement
  (variable_list
    (dot_index_expression . (_) @definition.associated (identifier) @definition.var)))
]],
  lua_function_identifier = [[
(function_declaration
  name: (identifier) @definition.function)
  (#set! definition.function.scope "parent")
]],
  lua_function_dot = [[
(function_declaration
  name: (dot_index_expression
    . (_) @definition.associated (identifier) @definition.function))
  (#set! definition.method.scope "parent")
]],
  lua_function_method_index = [[
(function_declaration
  name: (method_index_expression
    . (_) @definition.associated (identifier) @definition.method))
  (#set! definition.method.scope "parent")
]],
  lua_for_clause = [[
 (for_generic_clause
   (variable_list
     (identifier) @definition.var))
]],
  lua_for_numeric = [[
 (for_numeric_clause
   name: (identifier) @definition.var)
,
]],
  lua_parameters = [[
 (parameters (identifier) @definition.parameter)
]],
  lua_reference = [[
 [
   (identifier)
 ] @reference
]],
}

return doom_queries
