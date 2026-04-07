# Neovim 0.12 Tree-sitter Notes

## Diagnosis

1. Neovim was recently upgraded from `0.11.x` to `0.12.1`.
2. `nvim-treesitter` was also updated to a new incompatible rewrite.
3. The current config still uses the legacy `0.11`-era setup API.
4. This creates two separate classes of failures:
   - startup/config errors from the removed `nvim-treesitter.configs` module
   - markdown Tree-sitter errors that were seen before the plugin update on the legacy branch

### Current evidence

- Neovim version: `NVIM v0.12.1`
- Locked `nvim-treesitter` revision: `4916d6592ede8c07973490d9322f187e07dfefac`
- Locked `markview.nvim` revision: `1861f959599ae03cfd59f56222a542035b0cd947`
- Locked `snacks.nvim` revision: `ad9ede6a9cddf16cedbd31b8932d6dcdee9b716e`

### Config mismatch

The current Tree-sitter spec in `init.lua` is still written for the old plugin API:

```lua
{
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
```

That no longer matches the plugin currently installed under `~/.local/share/nvim/lazy/nvim-treesitter`.

### Startup failure

After the update, Neovim fails with:

```text
module 'nvim-treesitter.configs' not found
```

That happens because the new plugin no longer ships `lua/nvim-treesitter/configs.lua`.

### Earlier markdown failure

Before the plugin update completed, markdown buffers were failing with errors like:

```text
attempt to call method 'range' (a nil value)
```

and stacks through:

- `vim/treesitter.lua`
- `nvim-treesitter/query_predicates.lua`
- markdown injections
- `markview.nvim`
- `snacks.nvim`

This matched an upstream `nvim-treesitter` issue on Neovim `0.12` and markdown fenced code blocks on the legacy branch.

### `diff` parser update failure

The `:Lazy update` run also hit a parser install problem:

```text
mv: cannot stat 'tree-sitter-diff-tmp/tree-sitter-diff-master': No such file or directory
```

Observed local state:

- extracted temp directory exists as `tree-sitter-diff-main`
- updater tried to rename `tree-sitter-diff-master`
- upstream `tree-sitter-diff` default branch is `main`

So the `diff` parser failure looks like an installer naming mismatch during update, not a missing repo or missing commit.

## Explanations

### Why the behavior changed after the Neovim upgrade

Neovim `0.12` changed Tree-sitter internals and the surrounding plugin ecosystem moved with it.

The old `nvim-treesitter` branch and API that worked on `0.11` is not the same plugin interface used by the new `0.12` rewrite. After updating both Neovim and plugins, the config is now pointing at interfaces that no longer exist.

### Why Markview and Snacks appeared in the stack traces

`markview.nvim` and `snacks.nvim` both interact with markdown buffers and Tree-sitter queries. They were not the root cause by themselves. They were surfacing a lower-level markdown injection problem in the old Tree-sitter stack.

In the current state, the more immediate blocker is the config/plugin API mismatch, not Markview itself.

### Why the old markdown error and the new startup error are different

They came from two different states of the system:

1. Legacy `nvim-treesitter` plus Neovim `0.12`
   - produced markdown runtime errors around `query_predicates.lua`
2. New rewritten `nvim-treesitter`
   - now fails earlier during config load because the config still references the removed legacy module

### Why the existing parsers are not enough

There are already parsers under:

- `~/.local/share/nvim/lazy/nvim-treesitter/parser/`

But the rewritten plugin defaults to installing and managing parsers under:

- `stdpath('data')/site`

So even though parser files exist, the config still needs to be migrated to the new setup model.

## Recommendations

### Recommended path

Migrate the config to the new `nvim-treesitter` `0.12` API instead of rolling back.

This is the safer long-term fix because the old branch was already showing markdown injection failures on Neovim `0.12`.

### Migration steps

1. Replace the legacy Tree-sitter spec.
   - remove `main = 'nvim-treesitter.configs'`
   - stop using legacy `opts.ensure_installed`, `highlight.enable`, and `indent.enable`
   - use `require('nvim-treesitter').setup {}` only for install-dir or installer settings

2. Enable Tree-sitter features the new way.
   - use `FileType` autocmds or `ftplugin` files
   - call `vim.treesitter.start()` for desired filetypes
   - set `vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"` where Tree-sitter indent is wanted
   - set fold options separately if desired

3. Reinstall parsers after migration.
   - install into the new default location under `stdpath('data')/site`
   - verify markdown, markdown_inline, lua, vim, query, and other required parsers

4. Handle `diff` separately.
   - temporarily remove `'diff'` from the install list while migrating
   - re-add it after the rest of Tree-sitter is stable
   - if needed, override the parser recipe to use `branch = 'main'`

5. Re-test markdown after the migration.
   - open a markdown file with fenced code blocks
   - verify there are no Tree-sitter redraw errors
   - then confirm `markview.nvim` and `snacks.nvim` behavior

### Fallback option

If immediate stability is more important than migration work, pin `nvim-treesitter` back to the legacy `master` branch temporarily. That may restore the old config shape, but it is not ideal on Neovim `0.12` because it was already showing markdown-related failures.

### Recommended order of work

1. Fix the `nvim-treesitter` config mismatch first.
2. Get Neovim booting cleanly again.
3. Reinstall parsers in the new location.
4. Re-test markdown.
5. Only then spend time on `diff`, Markview, or Snacks follow-up issues.
