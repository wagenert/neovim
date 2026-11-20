vim.pack.add({
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.cmp' },
})

local cmp = require('blink.cmp')
cmp.build():pwait()

cmp.setup({
	keymap = {
		preset = "default",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		menu = {
			auto_show = function()
				return vim.bo.filetype ~= "markdown"
			end,
		},
	},
	-- signature help while typing function calls (was previously unset)
	signature = { enabled = true },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	-- snippets now use blink's native engine — LuaSnip dependency removed
	fuzzy = {
		implementation = "rust",
	},
})

vim.lsp.config['*'] = {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
}

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          'vim'
        }
      },
      telemetry = { enable = false }},
    }
  })

