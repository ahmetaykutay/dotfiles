local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

local plugins = {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"mbbill/undotree",
	{ "neovim/nvim-lspconfig" },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
		},
	},
	{ "nvim-lualine/lualine.nvim" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{ "smithbm2316/centerpad.nvim" },
	{ "christoomey/vim-tmux-navigator" },
	{
		"ibhagwan/fzf-lua",
		opts = {},
		config = function()
			local fzf = require("fzf-lua")
			fzf.register_ui_select()
			fzf.setup({})
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,
	},
}

require("lazy").setup(plugins, {
	rocks = {
		enabled = false,
	},
})
