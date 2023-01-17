local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- reccomended by docs
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF]])

nvimtree.setup({
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "",
					arrow_open = "",
				},
			},
		},
	},
	view = {
		width = 30,
	},
	actions = {
		open_file = {
			resize_window = false,
			window_picker = {
				enable = false,
			},
		},
	},
})
