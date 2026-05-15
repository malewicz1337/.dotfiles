return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"query",
				"tsx",
				"svelte",
				"css",
				"html",
				"javascript",
				"typescript",

				"vimdoc",
				"lua",

				"bash",
				"make",
				"nginx",

				"c",
				"rust",
				"zig",
				"go",
				"c_sharp",
				"elixir",
				"heex",
				"eex",
				"haskell",

				"markdown",
				"markdown_inline",
				"json",
				"yaml",
				"toml",

				"regex",
				"dockerfile",
			}

			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
