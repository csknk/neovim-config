local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

-- Helper function to get filename (no extension)
local function filename_to_title()
  local fname = vim.fn.expand "%:t:r"
  return fname ~= "" and fname or "untitled"
end
-- Helper: current date/time in DD/MM/YYYY_HH:MM:SS
local function current_datetime() return os.date "%d/%m/%Y_%H:%M:%S" end

-- Factory: build a new frontmatter node table each time
local function frontmatter_nodes()
  return {
    t "---",
    t { "", "title: " },
    f(filename_to_title),
    t { "", "date: " },
    f(current_datetime),
    t { "", "---" },
  }
end

ls.add_snippets("markdown", {
  s({ trig = "frontmatter", name = "Frontmatter" }, frontmatter_nodes()),
  s({ trig = "fm", name = "Frontmatter (alias)" }, frontmatter_nodes()),
})
