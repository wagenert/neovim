-- 1. Download and load Telescope alongside its core dependency
vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim', name = 'plenary' },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim.git', name='telescope-fzf-native', build = 'make' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', name = 'telescope' }
})

-- 2. Initialize Telescope with your preferences
local telescope = require('telescope')
telescope.setup({
  defaults = {
    -- Your custom configuration goes here
  }
})

-- 3. Map your favorite keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Help Tags' })

