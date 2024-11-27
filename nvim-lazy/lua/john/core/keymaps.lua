vim.g.mapleader = " "

local keymap = vim.keymap

-- General keymaps
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode using jk" })

keymap.set("n", "<leader>cc", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "x", '"_x', { desc = "Delete single character in normal mode without copying into register" })

keymap.set("n", "J", "<C-d>zz", { desc = "use capital J for half page jumps, but also center the view" })
keymap.set("n", "K", "<C-u>zz", { desc = "use capital K for half page jumps, but also center the view" })

keymap.set("n", "G", "Gzz", { desc = "center the view after jumping to the bottom of the file" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move lines while highlighted" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move lines while highlighted" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("v", "m", "<Esc>", { desc = "Use m to esc while in visual line mode" })
keymap.set("n", "r", "<C-r>", { desc = "Use r to redo instead of ctrl-r" })
keymap.set("n", "E", "ea", { desc = "capital E will move to the end of the word and enter insert mode" })
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Ergonomic save" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make split windows equal width" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" })
keymap.set(
  "n",
  "<leader>tt",
  "<C-w>s :terminal<CR> :resize 10<CR> A",
  { desc = " open new terminal window horizonally, resize and start from insert mode" }
)
keymap.set(
  "n",
  "<leader>vt",
  "<C-w>v :terminal<CR> :vertical resize 50<CR> A",
  { desc = "open new terminal window vertically, resize and start from insert mode" }
)

--Tabs
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tq", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })

-- my plugins
vim.keymap.set("n", "<leader><leader>t", ":ClockShowTime<cr>")
vim.keymap.set("n", "<leader><leader>s", ":ClockSelectTime<cr>")
vim.keymap.set("n", "<leader><leader>dt", ":ClockToggleTimer<cr>")
