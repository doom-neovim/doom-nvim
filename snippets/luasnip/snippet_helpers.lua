local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

return {
    lua = {
        -------------------------------------
        ---       SNIPPET TEMPLATES       ---
        -------------------------------------

	    s("snippet_node", {
	        t( "s(\"" ), i(1, "snippet_title"), t({  "\", {", "\t" }),
            i(0,  "snippet_body"),
	        t( { "", "})," }),
	    }),

	    s("snippet_ti", {
	        t( "s(\"" ), i(1, "snippet_title"), t({  "\", {", "\t" }),

            t("t(\""), i(2, "text1"), t("\"),"),

        	t( "i("), i(3, "1"), t( ", \""), i(4, "desrc"), t( "\"), "),

	        t( { "", "})," }),
	    }),

	    s("snippet_tit", {
	        t( "s(\"" ), i(1, "snippet_title"), t({  "\", {", "\t" }),

            t("t(\""), i(2, "text1"), t("\"),"),

        	t( "i("), i(3, "1"), t( ", \""), i(4, "desrc"), t( "\"), "),

            t("t(\""), i(5, "text2"), t("\"),"),

	        t( { "", "})," }),
	    }),

	    ------------------------------
	    ---       TEXT NODES       ---
	    ------------------------------
	    s("tnode simple", {
	        t( "t(\""), i(1, "text_node"), t( "\"), "),
	    }),
	    s("tnode before", {
	        t( "t({ \"\", \""), i(1, "text_node"), t( "\"}), "),
	    }),
	    s("tnode after", {
	        t( "t({ \""), i(1, "text_node"), t( "\", \"\" }), "),
	    }),
	    s("tnode both", {
	        t( "t({ \"\", \""), i(1, "text_node"), t( "\", \"\" }), "),
	    }),

        s("tnode choice", c(1, {
	        sn(nil, {
	            t( "t(\""), i(1, "text_node"), t( "\"), "),
	        }),
	        sn(nil, {
	            t( "t({ \"\", \""), i(1, "text_node"), t( "\"}), "),
	        }),
	        sn(nil, {
	            t( "t({ \""), i(1, "text_node"), t( "\", \"\" }), "),
	        }),
	        sn(nil, {
	            t( "t({ \"\", \""), i(1, "text_node"), t( "\", \"\" }), "),
	        }),
        })),

        --------------------------------
        ---       INSERT NODES       ---
        --------------------------------

	    s("insert_node", {
	        t( "i("), i(1, "1"), t( ", \""), i(2, "desrc"), t( "\"), "),
	    }),

        ----------------------------------
        ---       FUNCTION NODES       ---
        ----------------------------------

        s("function_node", {
	        t( "f("), i(1, "fn"), t( ", "), i(2, "{}"), t( ", "), i(3, "arg??"),   t( "), "),
	    }),

	    -- f(function() return {"e"} end, {}),   -- Seems related to having `t` and then `f` with only t it works fine
        -- 	f(function(args) return "Still only counts as text!!" end, {}),
	    -- f(function(args, snip) return
	    --     "Captured Text: " .. snip.captures[1] .. "." end, {}),
	    -- f(function(_, snip)
	    -- 	return "Triggered with " .. snip.trigger .. "."
	    -- end, {}),
        -- 	f(function(args, snip, user_arg_1) return args[2][1] .. user_arg_1 end,
        -- 		{1, 2},
        -- 		"Will be appended to text from i(0)"),
	    -- f(function(_, snip)
	    -- 	return snip.env.TM_SELECTED_TEXT[1] or {}
	    -- end, {}),

        --------------------------------
        ---       CHOISE NODES       ---
        --------------------------------

	    -- s("choice_node", {
	    --     snippet_body
	    -- }),

        -- s("cnode", c(1, {
 	    --   t("Ugh boring, a text node"),
 	    --   i(nil, "At least I can edit something now..."),
 	    --   f(function(args) return "Still only counts as text!!" end, {})
        -- })),

	    -- s(
	    -- 	"fmt1",
	    -- 	fmt("To {title} {} {}.", {
	    -- 		i(2, "Name"),
	    -- 		i(3, "Surname"),
	    -- 		title = c(1, { t("Mr."), t("Ms.") }),
	    -- 	})
	    -- ),

	    -- s("for", {
	    -- 	t"for ", c(1, {
	    -- 		sn(nil, {i(1, "k"), t", ", i(2, "v"), t" in ", c(3, {t"pairs", t"ipairs"}), t"(", i(4), t")"}),
	    -- 		sn(nil, {i(1, "i"), t" = ", i(2), t", ", i(3), })
	    -- 	}), t{" do", "\t"}, i(0), t{"", "end"}
	    -- })


	    ---------------------------------
	    ---       DYNAMIC NODES       ---
	    ---------------------------------

	    -- s("dynamic_node", {
	    --     snippet_body
	    -- }),
    }
}
