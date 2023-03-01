local hour = os.date("%H")

local status

-- use nightfly if its past 7am(day) and then use moonfly after 6pm(night)
if tonumber(hour) <= 7 or tonumber(hour) >= 18 then
	status = pcall(vim.cmd, "colorscheme moonfly")
	--[[ require("kanagawa").setup({
		colors = {
			bg = "#000000",
		},
	})
	status = pcall(vim.cmd, "colorscheme kanagawa") ]]
else
	status = pcall(vim.cmd, "colorscheme nightfly")
end

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#f87171" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#facc15" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a78bfa" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#38bdf8" })

vim.api.nvim_set_hl(0, "Visual", { bg = "#059669" })
vim.api.nvim_set_hl(0, "String", { fg = "#ecc48d" })

if not status then
	print("Colorscheme not found!")
	return
end
