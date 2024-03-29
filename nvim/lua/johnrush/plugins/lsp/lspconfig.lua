local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

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
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
	--keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	--keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	--keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	--keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	--keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
	--keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
	--keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	--keymap.set("n", "L", "<cmd>Lspsaga hover_doc<CR>", opts)
	--keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)

	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
	end
end

-- used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
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
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["phpactor"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
