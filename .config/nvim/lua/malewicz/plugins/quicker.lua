return {
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		opts = {
			buflisted = false,
			number = true,
			relativenumber = true,
			signcolumn = "auto",
			winfixheight = true,
			wrap = false,
		},
		use_default_opts = true,
		edit = {
			-- Enable editing the quickfix like a normal buffer
			enabled = true,
			-- Set to true to write buffers after applying edits.
			-- Set to "unmodified" to only write unmodified buffers.
			autosave = "unmodified",
		},
		constrain_cursor = true,
		highlight = {
			-- Use treesitter highlighting
			treesitter = true,
			-- Use LSP semantic token highlighting
			lsp = true,
			-- Load the referenced buffers to apply more accurate highlights (may be slow)
			load_buffers = false,
		},
		borders = {
			vert = "┃",
			-- Strong headers separate results from different files
			strong_header = "━",
			strong_cross = "╋",
			strong_end = "┫",
			-- Soft headers separate results within the same file
			soft_header = "╌",
			soft_cross = "╂",
			soft_end = "┨",
		},
		trim_leading_whitespace = "common",
		keys = {
			{
				"<leader>q",
				function()
					require("quicker").toggle()
				end,
				desc = "Toggle quickfix",
			},
			{
				"<leader>l",
				function()
					require("quicker").toggle({ loclist = true })
				end,
				desc = "Toggle loclist",
			},
		},
	},
}
