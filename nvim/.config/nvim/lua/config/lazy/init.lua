-- install lazy.nvim
local lazy_utils = require("config.lazy.utils")
lazy_utils.bootstrap()

-- load plugins
require("lazy").setup({
	spec = lazy_utils.generate_import_specs(),
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
