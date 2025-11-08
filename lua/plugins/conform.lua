-- if true then return {} end
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
      markdown = { "prettierd", "markdownlint" }, -- prettierd for table formatting, markdownlint enables auto-formatting of bare urls
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
