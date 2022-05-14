--[[
--
-- Hi,
--
-- I have a question about a query that I am trying to write.
--
-- My goal is to build a neovim config modules manager UI for doom-nvim.
-- The idea is to capture each `category` and all of its containing `enabled/disabled` module entries.
--
-- Then put them in a telescoper picker that then would eg. allow one to search for
-- a module and then toggle it on/off.
--
-- DESCRIBE HOW IS MY QUERY GOING:
--
--
--
--
----]


----------------------------------------------------------------------------------------
# A. MY QUERY

(return_statement
  (expression_list
    (table_constructor
      (field name: (identifier) @modules.category
        value: (table_constructor [
		(comment) @modules.disabled (#lua-match? @modules.disabled "%-%-%s\"[%w%-_]+\",")
		(field) @modules.enabled
]
 	))
  )
)
)

----------------------------------------------------------------------------------------
# B. THE CONFIG MODULES TABLE

return {
  category1 = { -- <--------- @modules.category
    "entry1", -- <---- capture as @module.enabled
    "entry2", -- <---- capture as @module.enabled
  },
  category2 = {-- <--------- @modules.category
    -- comment <<< ignore regular comment
    "entry3",
    "entry4",
    "entry5",
  },
  category3 = {-- <--------- @modules.category

    "entry6", -- <---- capture as @module.enabled
    -- "entry7", -- <---- capture as @module.disabled
  },
}
