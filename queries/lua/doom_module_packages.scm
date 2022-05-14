(assignment_statement (variable_list
(dot_index_expression . (_) @definition.associated (identifier) @definition.var)) @varl)
(#eq? @definition.var "packages")

(assignment_statement (expression_list (table_constructor [
(field value: (string) @package_string)
(field value: (table_constructor (field value: (string) @package_string )))
])))

