if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
print ">>> disable-null-ls-defaults.lua loaded"
return {
  "AstroNvim/astrolsp",
  opts = {
    features = {
      null_ls = false, -- 🚫 disables AstroNvim's auto-registered null-ls setup
    },
  },
}
