vim.pack.add {
  {src = 'https://github.com/voldikss/vim-floaterm'}
}

vim.keymap.set('n', '<leader>t', ':FloatermNew<CR>', { desc = 'New floating terminal'})
