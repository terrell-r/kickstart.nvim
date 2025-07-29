return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/obsidian-work/work/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/obsidian-work/work/*.md',
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see above for full list of optional dependencies ☝️
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- Disables legacy commands
    workspaces = {
      -- {
      --   name = 'personal',
      --   path = '~/vaults/personal',
      -- },
      {
        name = 'work',
        path = '~/obsidian-work/work',
      },
    },
    templates = {
      folder = 'zTools/Templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },

    daily_notes = {
      folder = '0Daily',
      date_format = '%Y-%m-%d',
      alias_format = '%B %-d, %Y',
      template = 'Daily Notes Template.md',
    },

    weekly_notes = {
      folder = '0Notes/weekly',
      date_format = '%Y-W%V',
    },

    monthly_notes = {
      folder = '0Notes/monthly',
      date_format = '%Y-%m',
    },

    yearly_notes = {
      folder = '0Notes/yearly',
      date_format = '%Y',
    },

    ui = {
      enable = true,
    },

    -- Set conceallevel for markdown files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 3
      end,
    }),

    -- see below for full list of options 👇
  },
}
