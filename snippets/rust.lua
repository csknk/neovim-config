local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  s({ trig = "for", dscr = "`for _ in _` loop", priority = 5000 }, {
    t { "for " },
    i(1, "pat"),
    t { " in " },
    i(2, "expr"),
    t { " {", "\t" },
    -- t { '	' },
    i(0),
    t { "", "}" },
  }),
  s(
    "newR",
    fmt(
      [[
    pub fn new({}: {}) -> Result<{}, &str> {{
        if {} {} {{
            return Err("{}");
        }}
        let {} = {};
        Ok({{ {} }})
    }}
  ]],
      {
        i(1, "args"),
        i(2),
        i(3, "Self"),
        rep(1),
        i(4, "cond"),
        i(5),
        i(6, "var"),
        i(7),
        i(8),
      }
    )
  ),

  s("ok", fmt("Ok({})", { i(1) })),

  s(
    "letoption",
    fmt(
      [[
    let {} = match {} {{
        Ok({}) => {},
        None => {},
    }};
  ]],
      {
        i(1, "data"),
        i(2, "optional_return"),
        i(3, "x"),
        rep(3),
        i(4, "default value"),
      }
    )
  ),
  --
  -- s(
  --   "letresult",
  --   fmt(
  --     [[
  --   let {} = match {} {{
  --       Ok({}) => {},
  --       Err(e) => {{
  --           eprintln!("{}: {:?}", e);
  --           {}
  --       }}
  --   }};
  --   {}
  -- ]],
  --     {
  --       i(1, "data"),
  --       i(2, "result"),
  --       i(3, "x"),
  --       rep(3),
  --       i(4, "error report"),
  --       i(5),
  --       i(0),
  --     }
  --   )
  -- ),
}
