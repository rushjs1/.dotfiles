local setup, comment = pcall(require, "Comment")
if not setup then
	return
end

comment.setup({
	opleader = {
		-- block comment keymap
		block = "nm",
	},
})
