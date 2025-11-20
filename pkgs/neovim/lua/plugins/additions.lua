return {
	{
		'vyfor/cord.nvim',
		event = 'VeryLazy',
		build = ':Cord update',
		opts = {},
		cond = vim.env.CORDLESS ~= 'true',
	},
	{
		'tpope/vim-fugitive',
		cmd = { 'Git' },
	},
	{
		dir = '~/dev/share.nvim/',
		opts = {},
		enabled = false,
	},
}
