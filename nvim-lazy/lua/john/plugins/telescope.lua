return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        --path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ["K"] = actions.move_to_middle,
            ["J"] = actions.move_to_bottom,
            ["q"] = actions.close,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    local keymap = vim.keymap

    keymap.set("n", "<leader>p", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
    keymap.set("n", "<leader>ff", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
    keymap.set("n", "<leader>ht", "<cmd>Telescope help_tags<cr>")
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find Todos" })
    keymap.set("n", "<leader>t", "<Plug>PlenaryTestFile", { desc = "Run test file" })

    keymap.set("n", "<leader>/", function()
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer]" })

    keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "[?] Find Recently opened files" })
    keymap.set("n", "<leader>td", require("telescope.builtin").diagnostics)
    keymap.set("n", "<leader>r", require("telescope.builtin").lsp_references)
  end,
}
