local hour = os.date("%H")

local status

-- use nightfly if its past 7am(day) and then use moonfly after 6pm(night)
if tonumber(hour) <= 7 or tonumber(hour) >= 18 then
	--status = pcall(vim.cmd, "colorscheme moonfly")

	require("vscode").setup({
		disable_nvimtree_bg = true,
    --transparent = true,
		color_overrides = {
			vscBack = "#000000",
		},
	})

	status = pcall(vim.cmd, "colorscheme vscode")
else
	--[[ 	status = pcall(vim.cmd, "colorscheme kanagawa") ]]
	--[[ 	status = pcall(vim.cmd, "colorscheme nightfly") ]]
	--[[ 	status = pcall(vim.cmd, "colorscheme moonfly") ]]
	require("vscode").setup({
		disable_nvimtree_bg = true,
    --transparent = true,
		color_overrides = {
			vscBack = "#000000",
		},
	})

	status = pcall(vim.cmd, "colorscheme vscode")
end

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#f87171" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#facc15" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a78bfa" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#38bdf8" })

vim.api.nvim_set_hl(0, "Visual", { bg = "#059669" })
vim.api.nvim_set_hl(0, "String", { fg = "#ecc48d" })

vim.api.nvim_set_hl(0, "MatchParen", { bg = "#51504f", fg = "orange" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#DCDCAA" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#000000" })

if not status then
	print("Colorscheme not found!")
	return
end
