return {
  'magnusriga/markdown-tools.nvim',
  ft = 'markdown', -- Load only for markdown files
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Optional: Choose one of these for template picker
    'folke/snacks.nvim', -- Using snacks since it's already installed
    -- or 'nvim-telescope/telescope.nvim',
    -- or 'ibhagwan/fzf-lua',
  },
  opts = {
    -- Template directory for creating new notes
    template_dir = '~/obsidian-work/work/zTools/Templates',

    -- Use snacks picker (already installed in your config)
    picker = 'snacks',

    -- Frontmatter configuration for Obsidian compatibility
    frontmatter = {
      -- Generate unique IDs for notes
      id = function()
        return os.date '%Y%m%d%H%M%S'
      end,

      -- Use filename as title
      title = function(filename)
        return filename:gsub('%.md$', ''):gsub('-', ' '):gsub('^%l', string.upper)
      end,

      -- Date in Obsidian format
      date = function()
        return os.date '%Y-%m-%d'
      end,

      -- Time in Obsidian format
      time = function()
        return os.date '%H:%M'
      end,
    },

    -- Keymaps (using <leader>m prefix)
    keymaps = {
      -- Template and note creation
      new_note = '<leader>mn', -- Create new note from template
      new_note_here = '<leader>mN', -- Create new note in current directory

      -- Link management
      insert_link = '<leader>ml', -- Insert markdown link
      insert_wikilink = '<leader>mw', -- Insert wikilink

      -- Checkboxes
      insert_checkbox = '<leader>mc', -- Insert checkbox
      toggle_checkbox = '<leader>mt', -- Toggle checkbox state

      -- Headers
      insert_header = '<leader>mh', -- Insert header

      -- Tables
      insert_table = '<leader>mT', -- Insert table

      -- Text styling
      bold = '<leader>mb', -- Bold text
      italic = '<leader>mi', -- Italic text
      code = '<leader>mC', -- Code inline
      strikethrough = '<leader>ms', -- Strikethrough text

      -- Preview
      preview = '<leader>mp', -- Preview markdown
    },

    -- Commands to enable
    commands = {
      new_note = true,
      insert_link = true,
      insert_wikilink = true,
      insert_checkbox = true,
      toggle_checkbox = true,
      insert_header = true,
      insert_table = true,
      bold = true,
      italic = true,
      code = true,
      strikethrough = true,
      preview = true,
    },

    -- Local options for markdown buffers
    local_options = {
      wrap = true, -- Enable line wrapping
      spell = true, -- Enable spell check
      conceallevel = 2, -- Conceal markdown syntax (similar to obsidian.nvim)
    },

    -- List continuation on Enter
    list_continuation = {
      enable = true,
      -- Patterns for different list types
      patterns = {
        bullet = { '-', '*', '+' },
        number = { '%d+%.' },
        checkbox = { '- %[ %]', '- %[x%]', '- %[X%]' },
      },
    },
  },

  config = function(_, opts)
    require('markdown-tools').setup(opts)

    -- Additional autocmd for conceallevel (similar to obsidian.nvim setup)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
      end,
    })
  end,
}
