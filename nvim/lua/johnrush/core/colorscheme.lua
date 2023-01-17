local status, _ = pcall(vim.cmd, "colorscheme nightfly")

--[[ vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) ]]

if not status then
	print("Colorscheme not found!")
	return
end
