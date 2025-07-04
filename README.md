# AstroNvim Template

**NOTE:** This is for AstroNvim v5+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

To trigger snacks picker for LSP reference search, ensure that the following is placed in `lua/plugins/astrolsp.lua`:

```lua
    mappings = {
      n = {
        ["<leader>lR"] = {
          function() require("snacks.picker").lsp_references() end,
          desc = "References",
        },
      }
    },
```
