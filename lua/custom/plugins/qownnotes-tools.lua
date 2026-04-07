return {
  'magnusriga/markdown-tools.nvim',
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/snacks.nvim', -- For template picker
  },
  config = function()
    -- Configure markdown-tools with correct API
    require('markdown-tools').setup {
      -- Template directory for QOwnNotes/Nextcloud Notes
      template_dir = '~/Nextcloud/Notes/z_templates',

      -- Use snacks picker (already installed)
      picker = 'snacks',

      -- Frontmatter configuration using correct function names
      frontmatter_id = function()
        return os.date '%Y%m%d%H%M%S'
      end,

      frontmatter_title = function(filename)
        return filename:gsub('%.md$', ''):gsub('-', ' ')
      end,

      frontmatter_date = function()
        return os.date '%Y-%m-%d'
      end,

      frontmatter_tags = function()
        return {}
      end,

      frontmatter_custom = {
        time = function()
          return os.date '%H:%M:%S'
        end,
      },

      -- Auto-insert frontmatter
      insert_frontmatter = true,

      -- Enable local options for markdown files
      enable_local_options = true,

      -- Editor settings for markdown buffers
      wrap = true,
      conceallevel = 1,
      spell = true,
      spelllang = 'en_us',

      -- Auto-continue lists on Enter
      continue_lists_on_enter = true,

      -- File types to activate on
      file_types = { 'markdown', 'md' },
    }

    -- Custom function for daily notes with DevOpsSec template
    vim.api.nvim_create_user_command('DailyNote', function()
      local notes_dir = vim.fn.expand '~/Nextcloud/Notes/dailiy'
      local date = os.date '%Y-%m-%d'
      local filename = date .. '.md'
      local filepath = notes_dir .. '/' .. filename

      -- Create directory if it doesn't exist
      vim.fn.mkdir(notes_dir, 'p')

      -- Check if daily note already exists
      if vim.fn.filereadable(filepath) == 1 then
        vim.cmd('edit ' .. filepath)
      else
        -- Create new daily note from template
        local template_path = vim.fn.expand '~/Nextcloud/Notes/z_templates/daily-note.md'
        if vim.fn.filereadable(template_path) == 1 then
          vim.cmd('edit ' .. filepath)
          vim.cmd('0read ' .. template_path)
          -- Replace template placeholders
          vim.cmd [[%s/{{date}}/\=strftime('%Y-%m-%d')/ge]]
          vim.cmd [[%s/{{time}}/\=strftime('%H:%M')/ge]]
          vim.cmd [[%s/{{title}}/\=strftime('%A, %B %d, %Y')/ge]]
          vim.cmd [[%s/{{day_of_week}}/\=strftime('%A')/ge]]
        else
          -- Create basic daily note if template doesn't exist
          vim.cmd('edit ' .. filepath)
          local content = {
            date .. ' - Daily Log',
            string.rep('=', #date + 13),
            '',
            '## Tasks',
            '- [ ] ',
            '',
            '## Notes',
            '',
            '',
            '## Links',
            '',
          }
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
        end
      end
    end, { desc = 'Open or create daily note' })

    -- Keymap for daily note
    vim.keymap.set('n', '<leader>nd', ':DailyNote<CR>', { desc = '[N]otes: Open [D]aily note' })

    -- Auto-setup for markdown files in Nextcloud Notes
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = { '*/Nextcloud/Notes/**/*.md' },
      callback = function()
        vim.opt_local.conceallevel = 1
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 80
      end,
    })
  end,
}
