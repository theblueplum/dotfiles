local common = require('BluePlum.lazy')

return {
	{ common.icons, opts = {} },
	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {},
		event = common.event.BufWinEnter,
	},
	{
		'OXY2DEV/markview.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', common.icons },
		ft = 'markdown',
		opts = {
			preview = {
				icon_provider = 'mini',
			},
		},
	},
	{
		'sphamba/smear-cursor.nvim',
		opts = {
			time_interval = 17,
			anticipation = 0,
			damping = 0.8,

			cursor_color = '#b7bcb9',
			legacy_computing_symbols_support = true,
		},
	},
}
