return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local keymap = vim.keymap

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references in Telescope"
        keymap.set("n", "gtr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Show LSP Implementations"
        keymap.set("n", "gti", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gtd", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "Show LSP references"
        keymap.set("n", "gr", vim.lsp.buf.references, opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "go to implementation"
        keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- buffer needs instances of 'interface' type

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "hd", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    local MASON_ROOT = vim.fn.stdpath("data") .. "/mason"
    local VUE_PKG = MASON_ROOT .. "/packages/vue-language-server"

    local vue_language_server_path = VUE_PKG .. "/node_modules/@vue/language-server"

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      },
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "javascript", "typescript", "vue" },
          },
        },
      },
    })

    vim.lsp.config("vue_ls", {
      capabilities = capabilities,
      cmd = function(dispatchers, config)
        local project_root = config.root_dir or vim.fn.getcwd()
        local typescript_lib = vim.fs.find("node_modules/typescript/lib", {
          path = project_root,
          upward = true,
          type = "directory",
        })[1]

        if not typescript_lib then
          vim.notify(
            "vue_ls requires TypeScript in the project. Install it with your package manager (for example, `npm install --save-dev typescript`).",
            vim.log.levels.ERROR
          )
          return
        end

        return vim.lsp.rpc.start({ "vue-language-server", "--stdio", "--tsdk=" .. typescript_lib }, dispatchers)
      end,
    })

    vim.lsp.config("emmet_ls", {
      capabilities = capabilities,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
        "vue",
        "blade",
      },
    })

    vim.lsp.config("tailwindcss", {
      capabilities = capabilities,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "vue",
      },
    })

    vim.lsp.config("clangd", {
      capabilities = capabilities,
      filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
      },
    })

    vim.lsp.enable("lua_ls")
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("vue_ls")
    vim.lsp.enable("emmet_ls")
    vim.lsp.enable("tailwindcss")
    vim.lsp.enable("clangd")
  end,
}
