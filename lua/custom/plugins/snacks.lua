-- lazy.nvim
--
return {
  'folke/snacks.nvim',
  dependencies = { 'obsidian-nvim/obsidian.nvim' },
  ---@type snacks.Config
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
  },
}
