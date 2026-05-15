return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		lazy = false,
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						"%.git/",
						"%.cache",
						"%.DS_Store",
						"%.obsidian",
						"%.Trash",
						"%.sum",
						"package.json",
						"package-lock.json",
						"*.log",
						"dist",
						"build",
						"*.mjs",
						"*.svg",
					},
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-l>"] = actions.move_selection_previous,
							["<C-k>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
						n = {
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = { "--hidden" },
					},
					grep_string = {
						additional_args = { "--hidden" },
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			telescope.load_extension("fzf")
			local opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<leader>pf", ":Telescope find_files<CR>", opts)
			vim.keymap.set("n", "<leader>pg", ":Telescope live_grep<CR>", opts)
			vim.keymap.set("n", "<leader>pm", ":Telescope marks<CR>", opts)
			vim.keymap.set("n", "<leader>ps", ":Telescope grep_string<CR>", opts)
			vim.keymap.set("n", "<leader>pd", ":Telescope diagnostics<CR>", opts)
			vim.keymap.set("n", "<leader>ph", ":Telescope help_tags<CR>", opts)
			vim.keymap.set("n", "<leader>pk", ":Telescope keymaps<CR>", opts)
			vim.keymap.set("n", "<leader>pb", ":Telescope buffers<CR>", opts)
			vim.keymap.set("n", "<leader>pt", ":Telescope colorscheme enable_preview=true<CR>", opts)

			vim.keymap.set("n", "<leader>pS", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end, { desc = "Find Connected Words under cursor" })
		end,
	},
}
