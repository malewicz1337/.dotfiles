return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status")
			local theme = require("lualine.themes.rose-pine")

			for mode, sections in pairs(theme) do
				for section_name, colors in pairs(sections) do
					if mode ~= "inactive" and section_name == "a" then
						colors.fg = colors.bg
					end
					colors.bg = "NONE"
				end
			end

			vim.api.nvim_create_autocmd("RecordingEnter", {
				callback = function()
					lualine.refresh({ place = { "statusline" } })
				end,
			})

			vim.api.nvim_create_autocmd("RecordingLeave", {
				callback = function()
					local timer = vim.loop.new_timer()
					timer:start(
						50,
						0,
						vim.schedule_wrap(function()
							lualine.refresh({ place = { "statusline" } })
						end)
					)
				end,
			})

			lualine.setup({
				options = {
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					theme = theme,
					globalstatus = true,
				},
				sections = {
					lualine_b = {
						"branch",
						"diff",
						"diagnostics",
						{
							function()
								local reg = vim.fn.reg_recording()
								if reg == "" then
									return ""
								end
								return "● Rec @" .. reg
							end,
							color = { fg = "#ff9e64", gui = "bold" },
						},
					},
					lualine_c = {
						{
							function()
								return require("noice").api.status.mode.get()
							end,
							cond = function()
								return package.loaded.noice
							end,
						},
					},
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
						},
						-- { "fileformat" },
						-- { "filetype" },
					},
				},
			})
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("noice").setup({
				cmdline = {
					enabled = true,
					view = "cmdline",
					-- opts = { conceal = true },
				},
				messages = {
					enabled = true,
					view = "mini", -- Show messages in cmdline area
					view_error = "mini",
					view_warn = "mini",
					view_history = "messages",
					view_search = "virtualtext",
				},
				lsp = {
					progress = {
						enabled = true,
						view = "mini",
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				routes = {
					{
						filter = {
							event = "msg_show",
						},
						view = "mini",
						opts = { timeout = 3000 },
					},
					{
						filter = {
							event = "notify",
							find = "mason",
						},
						view = "mini",
						opts = { timeout = 3000 },
					},
					{
						filter = {
							event = "lsp",
							kind = "progress",
						},
						view = "mini",
						opts = { timeout = 3000 },
					},
					{
						filter = {
							event = "notify",
						},
						view = "mini",
						opts = { timeout = 3000 },
					},
				},
				presets = {
					bottom_search = true,
					command_palette = false, -- Disable popup command palette
					long_message_to_split = false, -- Keep long messages in cmdline
					inc_rename = false,
					lsp_doc_border = false,
				},
				views = {
					mini = {
						backend = "mini",
						relative = "editor",
						reverse = true,
						focusable = false,
						align = "message-right",
						timeout = 3000, -- Default timeout for mini view
						size = "auto",
						zindex = 60,
						position = {
							row = -1,
							col = "100%",
						},
						border = {
							style = "none",
						},
						win_options = {
							winblend = 0,
						},
					},
					cmdline_popup = {
						position = {
							row = "98%",
							col = "50%",
						},
						size = {
							width = "40%",
							height = "auto",
						},
						border = {
							style = "none", -- "none", "single", "double", "rounded", "solid", "shadow"
							padding = { 0, 0 }, -- {vertical, horizontal}
						},
					},
				},
				notify = {
					enabled = false,
				},
			})
		end,
	},
}
