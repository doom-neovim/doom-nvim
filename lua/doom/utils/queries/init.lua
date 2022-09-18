local queries = {}

queries.root_mod = function(name, section)
  return string.format(
    [[
(return_statement (expression_list
  (table_constructor
      (field
        name: (identifier) @section_key
        value: (table_constructor
              (field value: (string) @module_string (#eq? @module_string "\"%s\""))
        )
      )
  ) (#eq? @section_key "%s")
))
]],
    name,
    section
  )
end

queries.root_comments = function(section)
  return string.format(
    [[
(return_statement (expression_list
  (table_constructor
      (field
        name: (identifier) @section_key
        value: (table_constructor (comment) @section_comment)
      )
  ) (#eq? @section_key "%s")
))
]],
    section
  )
end

queries.root_section_table = function(section)
  return string.format(
    [[
(return_statement (expression_list
  (table_constructor
      (field
        name: (identifier) @section_key
        value: (table_constructor) @section_table)
  ) (#eq? @section_key "%s")
))
  ]],
    section
  )
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

queries.field = function(lhs_key, rhs_value)
  local rhs_tag
  if type(rhs_value) == "string" then
    rhs_value = '\\"' .. rhs_value .. '\\"'
    rhs_tag = "string"
  else
    rhs_tag = rhs_value
  end
  -- 100 -> "number"
  -- ALTERNATIVES:
  --    - inside of results when we collect entries.
  --    - inside of parser > this would be a nice fallback
  return string.format(
    [[
      (field
        name: (identifier) @key (#eq? @key "%s")
        value: (%s) @value (#eq? @value "%s")
      )
    ]],
    lhs_key,
    rhs_tag,
    rhs_value
  )
end

queries.mod_tbl = function(field_name)
  print("mod tbl >>>", vim.inspect(field_name))

  return string.format(
    [[
      (assignment_statement
        (variable_list
          name: (dot_index_expression
              table: (identifier)
              field: (identifier) @varl_name (#eq? @varl_name "%s")
            )

        )
        (expression_list value: (table_constructor) @rhs)
      )
    ]],
    field_name
  )
end

queries.pkg_table = function(table_path, spec_one)
  return string.format(
    [[
      (field
        name: (string) @name (#eq? @name "\"%s\"")
        value: (table_constructor
          (field
            value: (string) @repo
              (#eq? @repo "\"%s\"")
          )
        ) @pkg_table
      )
    ]],
    table_path,
    spec_one
  )
end

queries.config_func = function(config)
  print(vim.inspect(config))
  local q = ""
  if config.table_path then
    q = string.format([[@cfg_name (#eq? @cfg_name "\"%s\"")]], config.table_path)
  end
  return string.format(
    [[
      (assignment_statement
        (variable_list
          name:
            (bracket_index_expression
              table: (dot_index_expression
                  table: (identifier)
                  field: (identifier) @varl_name (#eq? @varl_name "configs"))
              field: (string) %s
            )
        )
        (expression_list value: (function_definition) @rhs)
      )
    ]],
    q
  )
end

queries.cmd_table = function(cmd)
  print("CMD >>>", vim.inspect(cmd))

  return string.format(
    [[
      (table_constructor
        . (field value: (string) @name (#eq? @name "\"%s\""))
        (field value: [(string) (function_definition)] @action)
      )
    ]],
    cmd.name
  )
end

queries.autocmd_table = function(autocmd)
  print("AUTOCMD >>>", vim.inspect(autocmd))
  return string.format(
    [[
      (field
        value: (table_constructor
          . (field value: (string) @event (#eq? @event "\"%s\""))
          . (field value: (string) @pattern (#eq? @pattern "\"%s\""))
          (field value: (function_definition) @action)
        )
      )
    ]],
    autocmd.event,
    autocmd.pattern
  )
end

queries.binds_table = function(bind)
  print("BIND >>>", vim.inspect(bind))

  -- todo: account for special cases when you have to assign the
  --          field name string
  --
  --    - mode
  --    - options
  --    - descr

  return string.format(
    [[
    (field
      value: (table_constructor
        .(field value: (string) @lhs (#eq? @lhs "\"%s\""))
        .[
          (field value: (string))
          (field
                value: (dot_index_expression
                field: (identifier)))
          ; (field) ; TODO: identifier
        ] @rhs
        .[
          (field value: (string) @ns (#eq? @ns "\"%s\""))
          (field
                name: (identifier) @key (#eq? @key "name")
                value: (string) @name (#eq? @name "\"%s\""))
        ] @name_field
      ) @bind_table
    ) @bind_field
    ]],
    bind[1],
    -- bind.rhs,
    bind.name,
    bind.name
  )
end

queries.leader_t = [[
  (field
    value: (table_constructor
        . (field value: (string) @ld (#eq? @ld "\"<leader>\""))
    ) @leader_table
  ) @leader_field
]]

queries.binds_branch = function(branch)
  print("BIND BRANCH >>>", vim.inspect(branch))

  return string.format(
    [[
      (field
        value: (table_constructor
        . (field value: (string) @lhs (#eq? @lhs "\"%s\""))
        . (field value: (table_constructor)) @child_table
        )
      )
    ]],
    branch[1]
    -- branch.rhs,
    -- branch.name
  )
end

return queries
