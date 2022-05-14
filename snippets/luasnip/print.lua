local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local r = require("luasnip.extras").rep

return {
	lua = {
        s("print_str", {
            t("print(\""),
            i(1, "desrc"),
            t("\")"),
        }),
        s("print_var1", {
            t("print(\""),
            i(1, "desrc"),
            t(": \" .. "),
            i(2, "the_variable"),
            t(")"),
        }),
        s("print_var2", {
            t("print(\""),
            i(1, "the_variable"),
            t(": \" .. "),
            r(1),
            t(")"),
        }),
        s("print_var3", {
            t("print(\""),
            i(1, "desrc"),
            t(" | "),
            i(2, "the_variable"),
            t(" : \" .. "),
            r(2),
            t(")"),
        }),
	}
}
