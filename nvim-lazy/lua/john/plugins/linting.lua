local checkForFile = function()
  print("checking for lint file")
  local dirList = vim.fn.systemlist("ls -a")

  for _, dirname in ipairs(dirList) do
    if dirname == ".eslintrc.js" or dirname == ".eslintrc.json" then
      print("Linting enabled")
      return true
    end
  end
end

local tryLint = function(lint, lint_augroup)
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      --print("calling lint.try_lint")
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

    if checkForFile() then
      tryLint(lint, lint_augroup)
    end

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
