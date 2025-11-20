--- Defaults to `{'n'}`
--- @alias Mode 'n'|'v'|'Q'|'t'|'i'|'c'
--- @alias Mapping string|fun(): nil

--- @type table<string, { [string]: Mapping, modes: (Mode)[]? }>
local keymap = {
	move_lines = {
		['<M-Up>'] = '<ESC>:move-2<CR>i',
		['<M-Down>'] = '<ESC>:move+<CR>i',
		modes = { 'i' },
	},
	half_screen_scroll = {
		['<C-Up>'] = '<C-u>zz',
		['<C-Down>'] = '<C-d>zz',
	},
	clipboard_yank = {
		['<leader>y'] = '"+y',
		modes = { 'n', 'v' },
	},
	terminal_escape = {
		['<ESC>'] = '<C-\\><C-n>',
		modes = { 't' },
	},
	terminal = {
		['<leader>t'] = function()
			OpenTerminal = OpenTerminal or nil

			local open_buf = vim.api.nvim_get_current_buf()

			if PreviousBuffer and open_buf == OpenTerminal then
				vim.api.nvim_set_current_buf(PreviousBuffer)
				PreviousBuffer = nil
				return
			end

			PreviousBuffer = open_buf

			if OpenTerminal then
				vim.api.nvim_set_current_buf(OpenTerminal)
				return
			end

			vim.cmd.term()
			OpenTerminal = vim.api.nvim_get_current_buf()
			vim.api.nvim_create_autocmd({ 'BufDelete' }, {
				callback = function()
					OpenTerminal = nil
				end,
				buffer = OpenTerminal,
			})
		end,
	},
	goto_last_buffer = {
		['<leader>l'] = ':e#<CR>',
	},
	scratch_pad = {
		['<leader>s'] = table.concat({
			':bo vs',
			':enew',
			':setlocal noswapfile',
			':setlocal bufhidden=hide',
			':set filetype=markdown',
			':set syntax=markdown',
			'',
		}, '<CR>'),
	},
	window_navigation = {
		['<M-q>'] = '<C-w>q',
		['<M-left>'] = '<C-w><left>',
		['<M-right>'] = '<C-w><right>',
		['<M-up>'] = '<C-w><up>',
		['<M-down>'] = '<C-w><down>',
	},
}

for _, tbl in pairs(keymap) do
	for key, value in pairs(tbl) do
		if key ~= 'modes' then
			local modes = tbl.modes --[[ @as Mode[] ]]
				or { 'n' }
			for _, mode in ipairs(modes) do
				--- @cast value Mapping
				vim.keymap.set(mode, key, value)
			end
		end
	end
end
