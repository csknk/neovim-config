return {
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                extraEnv = {
                  -- Adding this to allow sqlx to access offline cach in src/.sqlx
                  SQLX_OFFLINE = "true",
                  -- Optional: if you *also* want online when DB is up:
                  -- DATABASE_URL = "postgres://bank:bank@localhost:5432/bank_dev",
                },
              },
            },
          },
        },
      },
    },
  },
}
