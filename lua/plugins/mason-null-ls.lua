-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "markdownlint",
        -- add more arguments for adding more null-ls sources
      })
      opts.handlers = {
        markdownlint = function()
          local null_ls = require "null-ls"
          null_ls.register(null_ls.builtins.diagnostics.markdownlint.with {
            extra_args = { "--config", "~/.markdownlint.yaml" },
          })
        end,
      }
    end,
  },
}
