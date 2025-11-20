local common = require('BluePlum.lazy')

return {
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		event = common.event.VeryLazy,
		build = ':TSUpdate',
		opts = {
			ensure_installed = { 'lua', 'markdown', 'typescript', 'javascript', 'rust', 'json', 'toml' },

			highlight = {
				enable = true,
			},

			auto_install = true,
		},
	},
}
