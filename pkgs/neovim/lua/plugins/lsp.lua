local common = require('BluePlum.lazy')

return {
	-- Mason
	{ 'mason-org/mason.nvim', opts = {} },
	{
		'mason-org/mason-lspconfig.nvim',
		version = '1.*',
		config = function(lazy)
			local mason_lspconfig = require('mason-lspconfig')

			mason_lspconfig.setup(lazy.opts)
			mason_lspconfig.setup_handlers({
				vim.lsp.enable
			})

			vim.lsp.enable('nixd')
			vim.lsp.enable('rust_analyzer')
		end,
		dependencies = {
			'mason-org/mason.nvim',
		},
	},
	{
		'Saghen/blink.cmp',
		dependencies = { common.icons },
		version = '1.*',
		build = 'cargo build --release',
		opts = {
			keymap = {
				preset = 'default',

				['<Up>'] = { 'select_prev', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },

				['<Tab>'] = { 'accept', 'fallback' },
			},
			appearance = {
				nerd_font_variant = 'normal',
			},
			sources = {
				default = { 'lsp', 'buffer', 'path', 'omni' },
			},
			completion = {
				list = { selection = { auto_insert = false } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 700,
				},
				ghost_text = { enabled = true },
				menu = {
					auto_show = true,
					draw = {
						columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
						components = {
							kind_icon = {
								text = function(ctx)
									local icon, _, _ = common.icons_require().get('lsp', ctx.kind)
									return icon
								end,
							},
							kind = {
								text = function(ctx)
									return '(' .. ctx.kind .. ')'
								end,
								highlight = 'SpecialKey',
							},
						},
					},
				},
			},
			cmdline = {
				enabled = true,
				keymap = { preset = 'inherit' },
				sources = { 'buffer', 'cmdline' },
				completion = {
					list = { selection = { preselect = true, auto_insert = false } },
					ghost_text = { enabled = true },
					menu = {
						auto_show = true,
					},
				},
			},
			signature = { enabled = true, window = { show_documentation = true } },
		},
	},
}
