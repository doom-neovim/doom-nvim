(table_constructor
		(field) @modules.enabled
)

(table_constructor
		(comment) @modules.disabled (#lua-match? @modules.disabled "%-%-%s\"[%w%-_]+\",")
)

; (table_constructor
;       (field name: (identifier) @m.category ; (#lua-match? @m.category "")
; 	value: (table_constructor (field) @m.enabled ;(#lua-match? @m.enabled "")
; )))
;
; (table_constructor
;       (field name: (identifier) @m.category ; (#lua-match? @m.category "")
; 	value: (table_constructor (field) @m.disabled ;(#lua-match? @m.enabled "")
; )))





; (return_statement
;   (expression_list
;     (table_constructor
;       (field name: (identifier) @modules.category
;         value: (table_constructor [
; 		(comment) @modules.disabled ; (#lua-match? @modules.disabled "%-%-%s\"[%w%-_]+\",")
; 		(field) @modules.enabled
; ]
;  	))
;   )
; )
; )

; (return_statement
;   (expression_list
;     (table_constructor
;       (field name: (identifier)
;         value: (table_constructor
;
;  	))
;   )
; )
; )
