local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	lua = {
	    s("ctodo", { t("-- TODO: "), i(1, "todo_body"), }),
	    s("todo",  { t("TODO: "), i(1, "todo_body"), }),

	    s("cfix",  { t("-- FIX: "),  i(1, "fix_body"), }),
	    s("fix",   { t("FIX: "),  i(1, "fix_body"), }),

	    s("chack", { t("-- HACK: "), i(1, "hack_body"), }),
	    s("hack",  { t("HACK: "), i(1, "hack_body"), }),

	    s("cwarn", { t("-- WARN: "), i(1, "warn_body"), }),
	    s("warn",  { t("WARN: "), i(1, "warn_body"), }),

	    s("cperf", { t("-- PERF: "), i(1, "perf_body"), }),
	    s("perf",  { t("PERF: "), i(1, "perf_body"), }),

	    s("cnote", { t("-- NOTE: "), i(1, "note_body"), }),
	    s("note",  { t("NOTE: "), i(1, "note_body"), }),
	}
}
