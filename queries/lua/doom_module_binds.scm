;; i want to write the captures so that I recieve the table constructtor
;; whose children can be iteraded instantly.


;;;;;;;; CAPTURE MODULE.BINDS TABLE ;;;;;;;;

(assignment_statement (variable_list
(dot_index_expression . (_) @definition.associated (identifier) @doom_module.binds_definition)
(#eq? @doom_module.binds_definition "binds")
)
  (expression_list value: (table_constructor) @doom_module.binds_table)
  )

;;;;;;;; CAPTURE MODULE.BINDS TABLE ;;;;;;;;

; expects there to be ONLY ONE returned table...
(return_statement
  (expression_list
    (table_constructor
      (field
	(identifier) @settings
	(table_constructor) @doom_root.settings_table
	) (#eq? @check "settings")
      )    ))

;;;;;;;; CAPTURE MODULE.PACKAGES TABLE ;;;;;;;;


; capture leader table, { "<leader>" }
; I am not sure how to do this without getting other nodes as well which I don't want.

; ; branch
; (field
;   value: (table_constructor
;     .(field
;       value: (string) @branch.char_field) ; "D"
;     .(field
;       name: (identifier) @branch.name_key ; "name"
;       value: (string) @branch.name_value) ; "+Doom"
;     .(field
;       value: (table_constructor) @branch.maps_table) ; { ... }
; ))@branch.field
;
; ; I beilieve that the `.` matches the exact order for the first nodes `char_seq` and `action`
; (field
;   value: (table_constructor
;
;     . (field value: (string) @mapping.char) ; can be mult chars
;
;     . (field value: [
; 		(string)
; 		(identifier) ; can you use function ids like so: `"x", my_func, name =..`
; 		(function_definition)
; 		(dot_index_expression)] @mapping.action)
;
;     (field name: (identifier) value: (string) @mapping.name)
;
;     (field name: (identifier) @mi value: (string) @mapping.mode )?
;
;     (field name: (identifier) value: (table_constructor (field)+ @mapping.option))? ; capture each option field as option
;
; )) @mapping.field
;
;
