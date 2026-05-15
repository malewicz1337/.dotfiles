return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua",
				dependencies = {
					{
						"DrKJeff16/wezterm-types",
						lazy = true,
						version = false,
					},
				},
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						{ path = "plenary.nvim", words = { "describe", "it", "assert" } },
						{ path = "wezterm-types", mods = { "wezterm" } },
					},
				},
			},
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"whoissethdaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"j-hui/fidget.nvim",
			"onsails/lspkind.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_lsp.default_capabilities()

			require("fidget").setup({})
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"codelldb",
					"clang-format",
					"ormolu",

					"prettier",
					"biome",
					"eslint_d",
					"stylelint",

					"stylua",

					"golines",
					"goimports",
					"golangci_lint_ls",

					"shfmt",
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"elixirls",
					"hls",
					"zls",
					"csharp_ls",
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"templ",
					"bashls",

					"ts_ls",
					"tailwindcss",
					"svelte",
					"html",
					"cssls",
					"jsonls",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,

					tailwindcss = function()
						require("lspconfig").tailwindcss.setup({
							capabilities = capabilities,
							filetypes = { "html", "css", "scss", "javascript", "typescript", "react", "templ" },
							init_options = { userLanguages = { templ = "html" } },
						})
					end,

					-- golangci_lint_ls = {},
					gopls = function()
						require("lspconfig").gopls.setup({
							capabilities = capabilities,
							settings = {
								gopls = {
									gofumpt = true,
									analyses = { unusedparams = true },
									staticcheck = true,
									useplaceholders = true,
									completeunimported = true,
								},
							},
						})
					end,

					elixirls = function()
						require("lspconfig").elixirls.setup({
							capabilities = capabilities,
							cmd = { "elixir-ls" },
						})
					end,

					hls = function()
						require("lspconfig").hls.setup({
							capabilities = capabilities,
							filetypes = { "haskell", "lhaskell", "cabal" },
						})
					end,

					svelte = function()
						require("lspconfig").svelte.setup({
							capabilities = capabilities,
							on_attach = function(client, _)
								vim.api.nvim_create_autocmd("bufwritepost", {
									pattern = { "*.js", "*.ts" },
									callback = function(ctx)
										client.notify("$/ondidchangetsorjsfile", { uri = ctx.match })
									end,
								})
							end,
						})
					end,

					zls = function()
						local lspconfig = require("lspconfig")
						lspconfig.zls.setup({
							root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
							settings = {
								zls = {
									enable_inlay_hints = true,
									enable_snippets = true,
									warn_style = true,
								},
							},
						})
						vim.g.zig_fmt_parse_errors = 0
						vim.g.zig_fmt_autosave = 0
					end,

					lua_ls = function()
						local lspconfig = require("lspconfig")
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									completion = {
										callSnippet = "Replace",
									},
									format = {
										enable = true,
										defaultConfig = {
											indent_style = "space",
											indent_size = "2",
										},
									},
								},
							},
						})
					end,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(e)
					local opts = { buffer = e.buf, silent = true, noremap = true }
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "L", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				end,
			})

			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-l>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-k>"] = cmp.mapping.select_next_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp" },
					{ name = "lazydev", group_index = 0 },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					fields = { "abbr", "kind", "menu" },
					expandable_indicator = true,
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})

			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
