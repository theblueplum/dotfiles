local common = require('BluePlum.lazy')

---@param exe string
---@param args { [number]: string, path: boolean? }
local function formatter(exe, args)
	return {
		function()
			local argv = {}

			for _, val in ipairs(args) do
				table.insert(argv, val)
			end

			if args.path ~= false then
				table.insert(argv, vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
			end

			return {
				exe = exe,
				args = argv,
				stdin = true,
			}
		end,
	}
end

local prettier = formatter('prettierd', {
	'--config-precedence prefer-file',
	'--single-quote',
	'--use-tabs',
	'--trailing-comma es5',
	'--bracket-same-line',
	'--stdin-filepath',
})

return {
	{
		'mhartington/formatter.nvim',
		event = common.event.BufWritePost,
		opts = {
			filetype = {
				javascript = prettier,
				typescript = prettier,
				markdown = prettier,
				css = prettier,
				json = prettier,
				html = prettier,
				scss = prettier,
				rust = formatter('rustfmt', { path = false }),
				lua = formatter('stylua', {
					'--indent-type Tabs',
					'--line-endings Unix',
					'--quote-style AutoPreferSingle',
					'--column-width' .. ' ' .. vim.o.columns,
					'-',
				}),
				nix = formatter('nixfmt', {
					'--indent=4',
					'--strict',
				}),

				['*'] = {
					function()
						if vim.lsp.buf.formatting then
							vim.lsp.buf.format()
						end
					end,
				},
			},
		},
		config = function(lazy)
			require('formatter').setup(lazy.opts)

			vim.api.nvim_create_augroup('__formatter__', { clear = true })
			vim.api.nvim_create_autocmd(common.event.BufWritePost, {
				group = '__formatter__',
				command = ':FormatWriteLock',
			})
		end,
	},
}
