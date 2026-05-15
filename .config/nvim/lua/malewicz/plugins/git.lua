return {
	{
		"ThePrimeagen/git-worktree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},

		config = function()
			local gitworktree = require("git-worktree")

			gitworktree.setup()

			require("telescope").load_extension("git_worktree")

			-- HACK: by default
			-- <Enter> - switches to that worktree
			-- <c-d> - deletes that worktree
			-- <c-f> - toggles forcing of the next deletion

			-- Create new worktree
			vim.keymap.set("n", "<leader>wl", function()
				require("telescope").extensions.git_worktree.git_worktrees()
			end, { desc = "list Git Worktree" })

			-- Switch/list worktrees
			vim.keymap.set("n", "<leader>wc", function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end, { desc = "Create Git Worktree Branches" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				map("n", "<leader>gh", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>gl", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>gg", gs.toggle_current_line_blame, "Toggle line blame")
				map("n", "<leader>gb", gs.blame, "Git blame file")
			end,
		},
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
		},
		init = function()
			vim.g.lazygit_config_file_path = vim.fn.expand("~/Library/Application Support/lazygit/config.yml")
		end,
	},
	{
		"tpope/vim-fugitive",
		dependencies = { "tpope/vim-rhubarb" },
		keys = {
			{
				"<leader>gu",
				"<cmd>GBrowse<CR>",
				desc = "Git Browse (file)",
			},
		},
	},
}
