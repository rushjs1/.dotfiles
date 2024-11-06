return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF]])

    nvimtree.setup({
      renderer = {
        icons = {
          glyphs = {
            folder = {
              --[[ arrow_closed = "",
              arrow_open = "", ]]
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
      filters = {
        custom = { ".DS_Store" }
      },
      git = {
       -- ignore = false
      }
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
  end
}

