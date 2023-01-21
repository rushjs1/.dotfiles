local status, _ = pcall(vim.cmd, "colorscheme nightfly")

--[[ vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) ]]

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#f87171" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#facc15" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a78bfa" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#38bdf8" })

vim.api.nvim_set_hl(0, "Visual", { bg = "#059669" })

if not status then
	print("Colorscheme not found!")
	return
end
