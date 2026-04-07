# Neovim Spell Check Reference

Quick reference for Neovim's built-in spell checker.

## Enable/Disable Spell Check

```vim
:set spell                    " Enable spell checking
:set spell spelllang=en_us    " Enable with specific language
:set nospell                  " Disable spell checking
```

## Navigation

| Command | Description |
|---------|-------------|
| `]s` | Jump to **next** misspelled word |
| `[s` | Jump to **previous** misspelled word |
| `]S` | Jump to next bad word (skip rare words) |
| `[S` | Jump to previous bad word (skip rare words) |

## Spelling Corrections

| Command | Description |
|---------|-------------|
| `z=` | Show spelling **suggestions** (interactive) |
| `1z=` | Use **first suggestion** automatically |
| `2z=` | Use **second suggestion** automatically |
| `3z=` | Use **third suggestion** automatically |

## Dictionary Management

| Command | Description |
|---------|-------------|
| `zg` | **Add word** to dictionary (mark as good) |
| `zG` | Add word to **internal** word list (temporary, current session) |
| `zw` | Mark word as **wrong** (misspelled) |
| `zW` | Mark word as wrong in **internal** list (temporary) |
| `zug` | **Undo** `zg` (remove from dictionary) |
| `zuw` | **Undo** `zw` (remove wrong marking) |
| `zuG` | Undo `zG` |
| `zuW` | Undo `zW` |

## Typical Workflow

1. Enable spell check: `:set spell`
2. Navigate to misspelled word: `]s`
3. View suggestions: `z=`
4. Select correction by typing its number
5. Continue to next word: `]s`

## Quick Fix Workflow (Fast)

1. Enable spell check: `:set spell`
2. Jump to word: `]s`
3. Auto-fix with first suggestion: `1z=`
4. Jump to next: `]s`
5. Repeat `1z=` and `]s`

## Auto-Enable for File Types

Add to your `init.lua` to enable spell check automatically for markdown and text files:

```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})
```

## Language Options

```vim
:set spelllang=en_us          " US English
:set spelllang=en_gb          " British English
:set spelllang=en_us,en_gb    " Both US and British
:set spelllang=en,es          " English and Spanish
```

## Check Current Settings

```vim
:set spell?           " Check if spell is enabled
:set spelllang?       " Check current language
```

## Visual Indicators

- Words with spelling errors are highlighted (usually underlined)
- Different colors may indicate:
  - **SpellBad**: Unrecognized word
  - **SpellCap**: Word should start with capital
  - **SpellRare**: Rare word
  - **SpellLocal**: Wrong spelling for selected region

## Tips

- **Don't want prompts?** Use `1z=` to always accept first suggestion
- **Add technical terms:** Use `zg` to add programming terms, acronyms, etc.
- **Undo mistakes:** If you accidentally add a wrong word, use `zug`
- **Temporary fixes:** Use `zG` for words you only want accepted in current session

## Related Help

```vim
:help spell
:help spell-quickstart
:help spelllang
```
