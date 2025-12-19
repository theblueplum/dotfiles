local common = require('BluePlum.lazy')
local fzf_lua = {
	find_files = function()
		require('fzf-lua').files()
	end,
	live_grep = function()
		require('fzf-lua').grep()
	end,
	buffers = function()
		require('fzf-lua').buffers()
	end,
	quick_fix = function()
		require('fzf-lua').lsp_code_actions()
	end,
	diagnostics = function()
		require('fzf-lua').diagnostics_workspace()
	end,
}

return {
	{
		'ibhagwan/fzf-lua',
		dependencies = { common.icons },
		keys = {
			{ '<leader>ff', fzf_lua.find_files },
			{ '<leader>fs', fzf_lua.live_grep },
			{ '<leader>fd', fzf_lua.diagnostics },
			{ '<leader>bb', fzf_lua.buffers },
			{ 'gra', fzf_lua.quick_fix },
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
