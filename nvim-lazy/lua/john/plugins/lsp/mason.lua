return {
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^1.0.0",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
  },
}
