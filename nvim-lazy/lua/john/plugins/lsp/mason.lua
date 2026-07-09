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
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        -- mason-lspconfig v1 maps this name to the vue-language-server package.
        "volar",
        "emmet_ls",
        "tailwindcss",
        "clangd",
      },
    },
  },
}
