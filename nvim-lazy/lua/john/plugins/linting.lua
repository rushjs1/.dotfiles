local eslint_config_files = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
}

local eslint_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  svelte = true,
}

local has_eslint_config = function(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local start_dir = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()

  return #vim.fs.find(eslint_config_files, {
    path = start_dir,
    upward = true,
  }) > 0
end

local tryLint = function(lint, lint_augroup)
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function(args)
      local filetype = vim.bo[args.buf].filetype

      if eslint_filetypes[filetype] and not has_eslint_config(args.buf) then
        return
      end

      lint.try_lint()
    end,
  })
end

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      php = { "phpcs" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    tryLint(lint, lint_augroup)

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
