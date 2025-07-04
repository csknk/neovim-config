local ls = require "luasnip"
local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
return {
  s(
    "header",
    fmt(
      [[
# {}
# author David Egan <csknk@protonmail.com>
#
# {}
# --------------------------------------------------------------------------------------
]],
      {
        f(function(_, snip) return snip.env.TM_FILENAME end),
        i(1, "Describe what this script does"),
      }
    )
  ),
}
