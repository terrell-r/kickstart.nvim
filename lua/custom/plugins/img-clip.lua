return {
  'HakonHarnes/img-clip.nvim',
  event = 'VeryLazy',
  opts = {
    default = {
      -- Disable filename prompt, use automatic naming
      prompt_for_file_name = false,
      -- Automatic filename format (timestamp-based)
      -- Format: YYYY-MM-DD-HH-MM-SS.png
      file_name = '%Y-%m-%d-%H-%M-%S',
      dir_path = function()
        return vim.fn.expand '%:p:h' .. '/attachments'
      end,
    },
  },
  keys = {
    -- suggested keymap
    { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
  },
}
