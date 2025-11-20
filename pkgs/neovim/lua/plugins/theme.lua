return {
	{
		'nyoom-engineering/oxocarbon.nvim',
		priority = 999,
		config = function()
			vim.cmd.colorscheme('oxocarbon')

			local groups = {
				Text = 'Identifier',
				Method = '@function.builtin',
				Function = 'Function',
				Constructor = '@character',
				Field = '@property',
				Variable = '@label',
				Class = 'Todo',
				Interface = 'Type',
				Module = 'Macro',
				Property = '@property',
				Unit = 'Type',
				Value = 'Number',
				Enum = 'String',
				Keyword = 'Identifier',
				Snippet = 'Identifier',
				Color = 'Identifier',
				File = 'Identifier',
				Folder = 'identifier',
				Reference = 'Identifier',
				EnumMember = 'String',
				Constant = '@constant.builtin',
				Struct = 'Type',
				Event = '@constant',
				Operator = 'Structure',
				TypeParameter = 'Type',
			}

			for key, value in pairs(groups) do
				vim.api.nvim_set_hl(0, 'BlinkCmpKind' .. key, { link = value })
			end

			vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { link = 'IncSearch' })
		end,
	},
}
