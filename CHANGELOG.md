# Neovim Configuration Changelog

## [2026-04-07] - Treesitter Parser Fix (Neovim 0.12.1)

### Fixed

#### Treesitter "Invalid field name operator" Error
- **Symptom**: Opening Lua files triggered highlighter error:
  ```
  Query error at 74:3. Invalid field name "operator"
  ```
- **Root Cause**: Stale `lua.so` parser in `~/.local/share/nvim/lazy/nvim-treesitter/parser/` (compiled Apr 2) lacked the `operator` field. The system parser (`/usr/lib/libtree-sitter-lua.so`, bundled with Neovim 0.12.1) has the field. The plugin parser loaded first on the runtimepath and took priority.
- **Resolution**: Removed orphaned `.so` parser files from the old plugin location. The new nvim-treesitter installs parsers to `~/.local/share/nvim/site/parser/` instead.

### Notes

#### Related References
- kickstart.nvim PR: https://github.com/nvim-lua/kickstart.nvim/pull/1748
- Config already had correct `main = 'nvim-treesitter.config'` (no init.lua edit needed)

#### Environment
- **Neovim**: v0.12.1
- **nvim-treesitter**: commit 4916d659 (new rewritten API)
- **Plugin manager**: lazy.nvim

---

## [2025-11-05] - Image Pasting & Documentation Updates

### Added

#### Neovim Configuration
- **SPELL-CHECK-REFERENCE.md** - Complete spell checker reference guide
  - Navigation shortcuts (`]s`, `[s`, etc.)
  - Correction commands (`z=`, `1z=`, etc.)
  - Dictionary management (`zg`, `zw`, etc.)
  - Workflows for quick fixes

### Fixed

#### Image Pasting in Tmux Sessions
- **Root Cause**: Missing tmux passthrough setting + snacks.nvim sha256 Blob error
- **Resolution Steps**:
  1. Added `set -gq allow-passthrough on` to `~/.tmux.conf`
  2. Updated `snacks.nvim` plugin to latest version (commit: 741f4b1)
  3. Re-enabled image rendering in snacks.nvim configuration
  4. Verified Ghostty terminal compatibility

#### Image Filename Prompts
- **Issue**: img-clip.nvim prompted for filename on every paste
- **Solution**: Configured automatic timestamp-based naming
  - Set `prompt_for_file_name = false`
  - Format: `YYYY-MM-DD-HH-MM-SS.png`

### Changed

#### `lua/custom/plugins/snacks.lua`
```lua
# Before (disabled due to error):
opts = {
  image = { enabled = false },
}

# After (fixed and re-enabled):
opts = {
  image = {
    enabled = true,
    resolve = function(path, src)
      local ok, obsidian_api = pcall(require, "obsidian.api")
      if ok and obsidian_api.path_is_note and obsidian_api.path_is_note(path) then
        return obsidian_api.resolve_image_path(src)
      end
    end,
  },
}
```

#### `lua/custom/plugins/img-clip.lua`
```lua
# Before:
opts = {
  -- empty or default settings
}

# After:
opts = {
  default = {
    prompt_for_file_name = false,
    file_name = "%Y-%m-%d-%H-%M-%S",
  },
}
```

#### `~/.tmux.conf`
```bash
# Added line 10:
set -gq allow-passthrough on
```

### Technical Details

#### Environment
- **Terminal**: Ghostty (fully compatible with kitty graphics protocol)
- **Tmux**: Running with `tmux-256color`
- **Neovim**: Inside tmux session
- **Image Plugins**:
  - img-clip.nvim (pasting)
  - snacks.nvim (rendering)
  - markview.nvim (markdown rendering)

#### Plugin Updates
- **snacks.nvim**: Updated to commit 741f4b1 (3 hours old at time of update)
  - Fixed sha256 Blob error in image rendering
  - Improved picker functionality
- **lazy.nvim**: Updated to 11.17.4
- **conform.nvim**: Updated with pkl support
- **telescope.nvim**: Breaking change - dropped Nvim 0.9 support

### Workflow Improvements

#### Image Pasting (Now Streamlined)
**Before**:
1. Press `<leader>p`
2. Prompted for filename
3. Type filename manually
4. Image pastes but doesn't display (tmux issue)

**After**:
1. Press `<leader>p`
2. Image instantly pastes with auto-generated name
3. Image displays inline immediately
4. Works perfectly in tmux sessions

#### Spell Checking (Documented)
- Complete reference guide created
- Quick workflow documented for CKA study notes
- Kubernetes terminology management tips included

### Future Considerations

- Consider auto-enabling spell check for markdown files
- May want to customize image naming patterns per project
- Monitor snacks.nvim updates for additional image features
- Add Kubernetes-specific terms to spell dictionary for CKA studying

---

## Notes

### Image Pasting Requirements
- ✅ Tmux: `allow-passthrough on`
- ✅ Terminal: Ghostty or Kitty
- ✅ Plugin: snacks.nvim (latest version)
- ✅ Plugin: img-clip.nvim (configured)

### Keybindings
- `<leader>p` - Paste image from clipboard (Space + p)
- `]s` / `[s` - Navigate spell check errors
- `z=` - Show spelling suggestions
