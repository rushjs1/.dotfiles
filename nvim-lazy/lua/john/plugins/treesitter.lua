local parsers = {
  "json",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "html",
  "css",
  "prisma",
  "markdown",
  "markdown_inline",
  "svelte",
  "graphql",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "php",
  "scss",
  "vue",
  "vimdoc",
  "blade",
  "c",
  "cpp",
}

local function register_blade_parser()
  require("nvim-treesitter.parsers").blade = {
    install_info = {
      url = "https://github.com/EmranMR/tree-sitter-blade",
      files = { "src/parser.c" },
      branch = "main",
    },
  }
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = function()
    if vim.fn.executable("tree-sitter") ~= 1 then
      error("nvim-treesitter requires the tree-sitter CLI; run `brew bundle --file=~/.dotfiles/Brewfile`")
    end

    register_blade_parser()
    require("nvim-treesitter").install(parsers):wait(300000)
  end,
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        register_blade_parser()
      end,
    })

    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })
  end,
  config = function()
    register_blade_parser()
    require("nvim-treesitter").setup()
    require("nvim-ts-autotag").setup()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "json",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "svelte",
        "graphql",
        "sh",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "php",
        "scss",
        "vue",
        "blade",
        "c",
        "cpp",
      },
      callback = function(args)
        local started = pcall(vim.treesitter.start, args.buf)

        if started then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
