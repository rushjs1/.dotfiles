return {
  {
    "mason-org/mason.nvim",
    version = "^2.0.0",
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
    version = "^2.0.0",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "pyright" },
      -- Server activation is managed explicitly in lspconfig.lua.
      automatic_enable = false,
    },
  },
}
