vim.api.nvim_create_user_command('Dot', 'edit ~/.config/nvim', {})

vim.cmd.cnoreabbrev('Git', 'GIt')
vim.api.nvim_create_user_command('GIt', function(ctx)
	local subcommand = ctx.fargs[1]
	if subcommand == 'log' then
		local argv = table.concat({
			'log',
			'--graph',
			'--abbrev-commit',
			'--decorate',
		}, ' ')

		local sliced = vim.list_slice(ctx.fargs, 2)
		vim.cmd.Git(argv .. ' ' .. table.concat(sliced, ' '))
		return
	end

	vim.cmd.Git(table.concat(ctx.fargs, ' '))
end, {
	nargs = '+',
})
