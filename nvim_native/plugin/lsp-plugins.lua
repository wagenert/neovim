vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig', name = 'nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim', name = 'mason' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim', name = 'mason-lspconfig' }
})

require('mason').setup({
  firewall = {
    enabled = true
  },
  ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
})

require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls' },
  automatic_enable = {
    'lua_ls',
  },
}
