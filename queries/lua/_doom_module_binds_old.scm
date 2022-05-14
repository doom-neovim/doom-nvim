(assignment_statement

  (variable_list name: (dot_index_expression
	table: (identifier)
	field: (identifier) @binds-table)) ; #eq "binds"
    	(#eq? @binds-table "binds")

  (expression_list value: (table_constructor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ; REGULAR BIND
      (field)* @binds-regular ; zero or more regular binds

      ; LEADER TABLE
      (field value: (table_constructor
      . (field value: (string) @leader-name)
      (field name: (identifier) value: (string) @leader-prefix)
      (#eq? @leader-name "\"<leader>\"")
      (#eq? @leader-prefix "\"+prefix\"")
      (field value: (table_constructor

	[(field) @lvl1bind
	(field value:
	(table_constructor
	. (field value: (string) @lvl1branch.char)
	(field name: (identifier) value: (string) @lvl1branch.name)
	(field value: (table_constructor

	  [(field) @lvl2bind
	   (field value:
	   (table_constructor
	   . (field value: (string) @lvl2branch.char)
	   (field name: (identifier) value: (string) @lvl2branch.name)
	   (field value: (table_constructor

	     [(field) @lvl3bind
	      (field value:
   	      (table_constructor
	      . (field value: (string) @lvl3branch.char)
	      (field name: (identifier) value: (string) @lvl3branch.name)
	      (field value: (table_constructor

	      )))) @lvl3branch.table]

  	   )))) @lvl2branch.table]

	)))) @lvl1branch.table]


      ))))? @leader-table ; ? -> optional table

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ) ; table_constructor
  ) ; expression_list
) ; assignment_statement
