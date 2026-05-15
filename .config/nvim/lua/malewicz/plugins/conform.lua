return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters = {
				csharpier = {
					command = "/Users/malewicz/.dotnet/tools/csharpier",
					args = { "format", "--write-stdout" },
				},
			},
			formatters_by_ft = {
				c = { "clang-format" },
				lua = { "stylua" },
				go = { "golines", "goimports", "gofmt" },
				rust = { "rustfmt", lsp_format = "fallback" },
				cs = { "csharpier" },
				elixir = { "mix" },
				zig = { "zigfmt" },
				haskell = { "ormolu" },

				typescript = { "biome", "prettier", "eslint_d", stop_after_first = true },
				typescriptreact = { "biome", "prettier", "eslint_d", stop_after_first = true },
				javascript = { "biome", "prettier", "eslint_d", stop_after_first = true },
				javascriptreact = { "biome", "prettier", "eslint_d", stop_after_first = true },
				css = { "biome", "prettier", stop_after_first = true },
				svelte = { "biome", "prettier", stop_after_first = true },

				json = { "biome", "prettier", stop_after_first = true },
				yaml = { "prettier" },

				bash = { "shfmt" },
				sh = { "shfmt" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
		})
		require("conform.formatters").golines = {
			prepend_args = { "-m", "80", "-w" },
		}
	end,
}
