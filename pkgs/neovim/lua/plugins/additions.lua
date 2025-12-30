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
		enabled = false, -- prefer using a terminal buffer with unnest.nvim
	},
	{
		dir = '~/dev/share.nvim/',
		opts = {},
		enabled = false,
	},
	{
		'brianhuster/unnest.nvim',
	},
}
