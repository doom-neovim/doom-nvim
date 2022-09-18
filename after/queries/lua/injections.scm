;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LUA TABLE KEY-STRING                                 ;;
;;  make tables easier to parse. make keys in the same color always
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ["n ]c"] = { <--- this
;;   expr = true,
;;   "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
;; },
;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; QUERY                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; STATIC AND STRING.FORMAT
;
; local var`ts_query...`
;
(variable_declaration
  (assignment_statement
    ; ts_query|tsq|query|q
    (variable_list) @vl (#match? @vl "^ts_query")
    (expression_list
      value: [
              (function_call
                name: (dot_index_expression
                  )
                arguments: (arguments
                    (string) @query
                  )
             )
            (string) @query
      ]
    )
  )
)

;
; STATIC
;
; queries.<name> = [[...]]
;
(assignment_statement
  (variable_list
    name: (dot_index_expression
      table: ( identifier ) @name (#eq? @name "queries")
      field: ( identifier )
      )
  )
  (expression_list
    value: ( string ) @query
    )
)


;
; FUNCTION RETURN
;
(assignment_statement
  (variable_list
    name: (dot_index_expression
      table: (identifier) @table (#eq? @table "queries")
    )
  )
  (expression_list
    value: (function_definition
      parameters: (parameters)
      body: (block
        (return_statement
          (expression_list
            (function_call
              name: ( dot_index_expression
                table: (identifier)
                field: (identifier)
              )
              arguments: (arguments ( string ) @query)
            )
          )
        )
      )
    )
  )
)
