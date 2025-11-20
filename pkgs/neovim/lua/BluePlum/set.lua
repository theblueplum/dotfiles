local opts = {
	mapleader = ' ',

	linenr = {
		number = true,
		relativenumber = true,

		cursorline = true,
		cursorlineopt = 'number',
	},

	-- Use tabs for indents
	indent = {
		autoindent = true,
		noexpandtab = true,
		tabstop = 4,
		shiftwidth = 4,
	},

	terminal = {
		termguicolors = true,
		shell = vim.env.SHELL or '/bin/sh',
	},

	split = {
		splitright = true,
		splitbelow = true,
	},

	search = {
		hlsearch = false,
		incsearch = true,
	},

	foldlevelstart = 99,
}

--- @param tbl table
local function apply(tbl)
	for key, value in pairs(tbl) do
		if type(value) == 'table' then
			apply(value)
		else
			if vim.fn.exists('&' .. key) == 1 then
				vim.opt[key] = value
			else
				vim.g[key] = value
			end
		end
	end
end

apply(opts)

-- Tabs for indenting
-- vim.opt.autoindent = true
-- vim.g.noexpandtab = true
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
--
-- -- Line numbers
-- vim.opt.number = true
-- vim.opt.relativenumber = true
-- vim.opt.cursorline = true
-- vim.opt.cursorlineopt = 'number'

-- Folding
-- vim.opt.foldlevelstart = 99

-- vim.g.mapleader = ' '

-- Terminal
-- vim.g.termguicolors = true
-- vim.opt.shell = '/bin/fish'

-- LSP
-- vim.lsp.inlay_hint.enable()

-- Splitting
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true

-- Make text readable
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
-- 	pattern = { '*.md', '*.typ' },
-- 	command = 'setlocal linebreak',
-- })

-- vim.api.nvim_create_autocmd('FileType', {
-- 	pattern = 'help',
-- 	command = 'setlocal linebreak',
-- })

-- Search
-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true
