vim.g.mapleader = " "

local keymap = vim.keymap

-- general keymaps

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>cc", ":nohl<CR>")

-- delete single character from normal mode without copying into register
keymap.set("n", "x", '"_x')

keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("n", "<leader>tt", "<C-w>s :terminal<CR> :resize 10<CR> A") -- open new terminal window horizonally, resize and start from insert mode
keymap.set("n", "<leader>vt", "<C-w>v :terminal<CR> :vertical resize 50<CR> A") -- open new terminal window vertically, resize and start from insert mode

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

--plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>p", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>ff", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<cr>")

--move lines while highlighted
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--center view upon virtical line movements
--[[ keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz") ]]

-- use capital J & K for half page jumps, but also center the view
keymap.set("n", "J", "<C-d>zz")
keymap.set("n", "K", "<C-u>zz")

--swap { and } for vertial paragraph jumps because why not
keymap.set("n", "{", "}")
keymap.set("n", "}", "{")

keymap.set("n", "G", "Gzz") -- center the view after jumping to the bottom of the file

-- search within current buffer
keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

--experimental
keymap.set("n", "<leader><CR>", "o<Esc>") -- create new empty line below but stay in normal mode (need one for capital O also.)
keymap.set("v", "m", "<Esc>") -- use m to escape while in visual line mode
keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find Recently opened files" })
keymap.set("n", "<leader>td", require("telescope.builtin").diagnostics)
keymap.set("n", "<leader>r", require("telescope.builtin").lsp_references)
keymap.set("n", "r", "<C-r>") -- use r to redo instead of ctrl-r
keymap.set("n", "E", "ea") -- capital E will move to the end of the word and enter insert mode
keymap.set("n", "<leader>w", ":w<CR>")
