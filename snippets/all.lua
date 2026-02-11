local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node

ls.add_snippets("all", {
  s("lic", {
    i(1, "description here"),
    t { "", "Copyright © " },
    f(function() return os.date "%Y" end),
    t {
      " David Egan",
      "",
      "",
      'Licensed under the Apache License, Version 2.0 (the "License");',
      "you may not use this file except in compliance with the License.",
      "You may obtain a copy of the License at",
      "",
      "\thttp://www.apache.org/licenses/LICENSE-2.0",
      "",
      "Unless required by applicable law or agreed to in writing, software",
      'distributed under the License is distributed on an "AS IS" BASIS,',
      "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.",
      "See the License for the specific language governing permissions and",
      "limitations under the License.",
    },
  }),
})
