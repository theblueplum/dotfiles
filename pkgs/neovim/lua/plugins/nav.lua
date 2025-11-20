local common = require('BluePlum.lazy')
local telescope = {
	find_files = function()
		require('telescope.builtin').find_files({ show_hidden = true })
	end,
	live_grep = function()
		require('telescope.builtin').live_grep()
	end,
	buffers = function()
		require('telescope.builtin').buffers()
	end,
}

return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { common.plenary },
		keys = {
			{ '<leader>ff', telescope.find_files },
			{ '<leader>fs', telescope.live_grep },
			{ '<leader>bb', telescope.buffers },
		},
	},

	{
		'stevearc/oil.nvim',
		opts = {
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
		},
		lazy = false,
		keys = {
			{ '<leader>ex', vim.cmd.Oil },
		},
	},
	{
		'Kaiser-Yang/flash.nvim',
		branch = 'develop',
		event = common.event.VeryLazy,
		opts = {
			modes = {
				char = {
					multi_line = false,
				},
			},
		},
	},
}
