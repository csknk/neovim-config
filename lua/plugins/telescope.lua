-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    opts.defaults = opts.defaults or {}

    opts.defaults.vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    }
    -- vim.tbl_extend("force", opts.defaults.vimgrep_arguments or {
    --   "rg",
    --   "--color=never",
    --   "--no-heading",
    --   "--with-filename",
    --   "--line-number",
    --   "--column",
    --   "--smart-case",
    -- }, { "--hidden", "--no-ignore" })

    return opts
  end,
}
