# Neovim Configuration Agent Guide

## Build/Lint/Test Commands

- **Format Lua**: `stylua .` (configured in .stylua.toml with 2-space indent, single quotes)
- **Lint**: Uses nvim-lint with markdownlint for markdown files
- **Check health**: `:checkhealth` in Neovim
- **Plugin management**: `:Lazy` (update with `:Lazy update`)

## Code Style Guidelines

- **Language**: Lua for all configuration files
- **Indentation**: 2 spaces (no tabs)
- **Quotes**: Single quotes preferred (`'string'` not `"string"`)
- **Line width**: 160 characters max
- **Parentheses**: Omit call parentheses where possible (`require 'module'` not `require('module')`)
- **Markdown file linting**: Always markdown-lint rules when possible working with .md files.
- [markdown-lint](https://github.com/updownpress/markdown-lint/tree/master/rules)

## File Structure

- `init.lua`: Main configuration entry point
- `lua/kickstart/plugins/`: Core plugin configurations
- `lua/custom/plugins/`: User-specific plugin additions
- Plugin files should return a table/array for lazy.nvim

## Naming Conventions

- Use snake_case for variables and functions
- Use descriptive names for keymaps with `desc` parameter
- Group related keymaps with leader key prefixes (`<leader>s` for search, `<leader>t` for toggle)

## Error Handling

- Use `pcall()` for optional plugin loading
- Check capabilities before setting up LSP features
- Provide fallbacks for missing dependencies (e.g., Nerd Font icons)
