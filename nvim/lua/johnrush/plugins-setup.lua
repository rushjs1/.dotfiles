-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- lua function that many plugins use
	use("nvim-lua/plenary.nvim")

	-- colorschemes
	--[[ use("bluz71/vim-nightfly-colors")
	use("bluz71/vim-moonfly-colors")
	use("rebelot/kanagawa.nvim")
	use("catppuccin/nvim")
	use({ "ellisonleao/gruvbox.nvim" }) ]]
	use("Mofiqul/vscode.nvim")

	--tmux & split window navigation
	use("christoomey/vim-tmux-navigator")
	use("szw/vim-maximizer")

	-- essential plugins
	use("tpope/vim-surround")
	use("vim-scripts/ReplaceWithRegister")

	--commenting with gc
	use("numToStr/Comment.nvim")

	--file explorer
	use("nvim-tree/nvim-tree.lua")

	-- icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	--fuzzy finding
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

	-- autocompletion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")

	--snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	-- managing & installing lsp servers
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- configuring lsp servers
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")

	use({
		"nvimdev/lspsaga.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("lspsaga").setup({})
		end,
	})

	use("jose-elias-alvarez/typescript.nvim")
	use("onsails/lspkind.nvim")

	--formatting and linting
	use({ "nvimtools/none-ls.nvim" })
	use("jay-babu/mason-null-ls.nvim")

	--treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	--auto closing
	use("windwp/nvim-autopairs")
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })

	use("lewis6991/gitsigns.nvim")

	use("rhysd/git-messenger.vim")

	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})
	use("andweeb/presence.nvim")

	use("wakatime/vim-wakatime")

	-- My Plugins
	use("~/plugins/clock")
	use("rushjs1/nuxt-goto.nvim")
	--[[ 	use("~/plugins/goto-alias") ]]

	--[[ use("~/plugins/html-jump")
	use("~/plugins/stackmap")
	use({
		"~/plugins/clock",
		config = function()
			require("clock").setup({
				keymap = "<space>m",
				title_pos = "left",
				window_pos = "center",
				timeout_duration = 3000,
			})
		end,
	}) ]]

	if packer_bootstrap then
		require("packer").sync()
	end
end)
