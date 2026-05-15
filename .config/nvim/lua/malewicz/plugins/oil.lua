return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = {
			{ "echasnovski/mini.icons", opts = {} },
			{
				-- "malewicz1337/oil-git.nvim",
				dir = "/Users/malewicz/Desktop/oil-git.nvim",
				dependencies = { "stevearc/oil.nvim" },
				opts = {
					show_file_highlights = true,
					show_directory_highlights = false,
					show_ignored_files = true,
				},
			},
		},
		config = function()
			require("oil").setup({
				columns = {
					{ "size", align = "right" },
					"icon",
				},
				keymaps = {
					["<C-j>"] = false,
					["<C-k>"] = false,
					["<C-l>"] = false,
					["<C-;>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, _)
						return name == ".DS_Store" or name == ".."
					end,
				},
				win_options = {
					wrap = true,
				},
				skip_confirm_for_simple_edits = true,
				watch_for_changes = true,
				delete_to_trash = true,
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "oil",
				callback = function()
					vim.opt_local.cursorline = true
				end,
			})

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "OilGitAdded", { fg = "#00ff00", bold = true })
					vim.api.nvim_set_hl(0, "OilGitModified", { fg = "#ffbf00", bold = true })
					vim.api.nvim_set_hl(0, "OilGitDeleted", { fg = "#ff0000", bold = true })
					vim.api.nvim_set_hl(0, "OilGitIgnored", { fg = "#5cc5ed", italic = true })
					vim.api.nvim_set_hl(0, "OilGitUntracked", { fg = "#bd93f9", bold = true })
				end,
			})
			vim.cmd("doautocmd ColorScheme")
		end,
	},
}
