return {
	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		lazy = false,
		config = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")

			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					java = false,
				},
				fast_wrap = {
					map = "<C-x>",
				},
			})

			local ts_conds = require("nvim-autopairs.ts-conds")

			npairs.add_rules({
				Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
				Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
				per_filetype = {
					["html"] = {
						enable_close = true,
						enable_rename = true,
					},
					["svelte"] = {
						enable_close = true,
						enable_rename = true,
					},
				},
			})

			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.diagnostic.config({
				underline = true,
				virtual_text = {
					spacing = 5,
					severity = { min = vim.diagnostic.severity.WARN },
				},
				update_in_insert = true,
			})
		end,
	},
}
