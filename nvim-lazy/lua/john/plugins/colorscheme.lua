return {
  "Mofiqul/vscode.nvim",
  priority = 1000,
  config = function()
    require("vscode").setup({
      disable_nvimtree_bg = true,
      --transparent = true,
      color_overrides = {
        vscBack = "#000000",
      },
    })

    vim.cmd("colorscheme vscode")

    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#f87171" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#facc15" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a78bfa" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#38bdf8" })

    vim.api.nvim_set_hl(0, "Visual", { bg = "#059669" })
    vim.api.nvim_set_hl(0, "String", { fg = "#ecc48d" })

    vim.api.nvim_set_hl(0, "MatchParen", { bg = "#51504f", fg = "orange" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#DCDCAA" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#000000" })
  end,
}
