# My Neovim Config

A modular Neovim setup using `lazy.nvim`.

## Features
- **Plugin Manager**: `lazy.nvim`
- **Theme**: Catppuccin
- **Language Support**: LSP, Treesitter, Blink.cmp (completion)
- **Formatting**: `conform.nvim` (Biome for web, CSharpier for .NET)
- **Debugging**: `nvim-dap`

## Structure
- `init.lua`: Main entry point.
- `lua/config/`: Core settings and keymaps.
- `lua/plugins/`: Plugin configurations.

## Installation
Clone into `~/.config/nvim`:
```bash
git clone <repo_url> ~/.config/nvim
```
Plugins will install automatically on first launch.
