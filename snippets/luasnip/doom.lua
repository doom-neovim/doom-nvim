local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	lua = {
	    s("doom_plugins_add_simple", {
	        t("{ '"), i(1, "plugin_name"), t("' },"),
	    }),
        s("doom_user_binding", {
            t( "{ '" ),
            i(1, "mode"),
            t("', '"),
            i(2, "binding"),
            t("', '"),
            i(3, "command"),
            t("', '"),
            i(4, "option"),
            t( "'},"),
        }),
        s("doom_map_oneline", {
            t("mappings.map( \""),
            i(1, "mode"),
            t("\", \""),
            i(2, "mapping"),
            t("\", \""),
            i(3, "command"),
            t("\", \""),
            i(4, "options"),
            t("\", \""),
            i(5, "category"),
            t("\", \""),
            i(6, "id"),
            t("\", \""),
            i(7, "desrc"),
            t("\" )"),
        }),
        s("doom_map_multline", {
            t({ "mappings.map(", "\t\"" }),
            i(1, "mode"),    t({ "\",", "\t\"" }),
            i(2, "mapping"), t({ "\",", "\t\"" }),
            i(3, "command"), t({ "\",", "\t\"" }),
            i(4, "options"), t({ "\",", "\t\"" }),
            i(5, "category"),t({ "\",", "\t\"" }),
            i(6, "id"),      t({ "\",", "\t\"" }),
            i(7, "desrc"),   t({ "\",", "\t" }),
            t(")"),
        }),
	}
}
