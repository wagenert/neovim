vim.g.mapleader = ' '

-- Copy/paste to clipboard
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y')
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p')
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set({ 'n', 'x' }, 'X', '"_d')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

vim.keymap.set('i', '<C-Space>', function()
    vim.lsp.completion.get()
end, { desc = 'Trigger LSP completion' })
