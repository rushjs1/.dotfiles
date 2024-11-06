local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local vue_language_server_path = require("mason-registry").get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language_server'

local keymap = vim.keymap

-- enable keybinds for available lsp server
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	--set keybinds
	keymap.set("n", "hd", vim.lsp.buf.hover)
	keymap.set("n", "[d", vim.diagnostic.goto_prev)
	keymap.set("n", "]d", vim.diagnostic.goto_next)
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- buffer needs instances of 'interface' type
	keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
	keymap.set("n", "<leader>vtd", vim.lsp.buf.type_definition, opts)
	keymap.set("n", "gr", vim.lsp.buf.references, opts)
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

	if client.name == "ts_ls" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
	end
end

-- used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig['ts_ls'].setup({
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' }
      }
    }
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["volar"].setup({
  init_options = {
    vue = {
      hybridMode = false
    }
  },
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["phpactor"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["gopls"].setup({
  capabilities = capabilities,
  on_attach = on_attach
})

