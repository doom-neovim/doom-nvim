; I beilieve that the `.` matches the exact order for the first nodes `char_seq` and `action`
(field
  value: (table_constructor

    . (field
	value: (string) @mapping.char) ; can be mult chars

    . (field
	value: [
		(string)
		;(identifier) ; can you use function ids like so: `"x", my_func, name =..`
		(function_definition)
		(dot_index_expression)] @mapping.action)

    (field name: (identifier) value: (string) @mapping.name)

    (field)? @mapping.mode

    (field name: (identifier)
	 value: (table_constructor (field)+ @mapping.option)? ; capture each option field as option

))
