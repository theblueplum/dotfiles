local lazy = require('BluePlum.lazy').bootstrap()

require('BluePlum')

if lazy then
	lazy.setup({
		spec = {
			{ import = 'plugins' },
		},
		checker = { enabled = false },
		change_detection = { notify = false },
		performance = { rtp = { reset = false } }
	})
end
