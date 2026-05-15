require("malewicz.core")
require("malewicz.lazy")

vim.cmd.colorscheme("gruvbox")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 120,
		})
	end,
})

vim.api.nvim_create_user_command("Stock", function(opts)
	local symbol = opts.args ~= "" and opts.args or "PEN"
	local api_key = "d5jb1qhr01qh37ujf430d5jb1qhr01qh37ujf43g"
	local url = string.format("https://finnhub.io/api/v1/quote?symbol=%s&token=%s", symbol, api_key)

	local buf = vim.api.nvim_create_buf(false, true)

	local width = 40
	local height = 5
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, false, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Stock Price: " .. symbol .. " ",
		title_pos = "center",
		focusable = false,
	})

	vim.defer_fn(function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, 5000)

	local output_data = {}
	vim.fn.jobstart({
		"curl",
		"-s",
		"-A",
		"Mozilla/5.0",
		url,
	}, {
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					table.insert(output_data, line)
				end
			end
		end,

		on_exit = function()
			local result_str = table.concat(output_data, "")
			local ok, parsed = pcall(vim.json.decode, result_str)

			if not ok or not parsed or parsed.c == 0 then
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "", "  Error: Invalid Symbol or Key." })
				return
			end

			local current = parsed.c or 0
			local prev = parsed.pc or 0
			local percent = parsed.dp or 0

			local sign = percent >= 0 and "+" or ""
			local formatted_change = string.format("%s%.2f%%", sign, percent)

			vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
				"",
				"  Current:    $" .. current,
				"  Prev Close: $" .. prev,
				"  Change:     " .. formatted_change,
			})
		end,
	})
end, { nargs = "?" })
