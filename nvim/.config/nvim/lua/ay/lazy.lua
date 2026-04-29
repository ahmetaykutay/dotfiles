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
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.enable("pyright")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("rust_analyzer")

			local map = vim.keymap.set
			map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			map("n", "gr", vim.lsp.buf.references, { desc = "References" })
			map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "pyright", "ts_ls", "rust_analyzer" },
		},
	},
	{ "nvim-lualine/lualine.nvim", opts = {} },
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
			fzf.setup({
				files = { fd_opts = "--type f --hidden --no-ignore" },
				grep = {
					rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore",
				},
				keymap = {
					fzf = {
						["ctrl-q"] = "select-all+accept",
					},
				},
			})
			local map = vim.keymap.set

			map("n", "<leader>ff", function()
				fzf.files({ hidden = true })
			end, { desc = "Fzf-lua Find Files (with hidden)" })
			map("n", "<leader>fg", fzf.live_grep, { desc = "Fzf-lua Live Grep (Full project search)" })
			map("n", "<leader>fb", fzf.buffers, { desc = "Fzf-lua Buffers" })
			map("n", "<leader>fh", fzf.help_tags, { desc = "Fzf-lua Help Tags" })
			map("n", "<leader>fp", fzf.git_files, { desc = "Fzf-lua Git Files" })
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,
	},
	{
		"romus204/tree-sitter-manager.nvim",
		dependencies = {}, -- tree-sitter CLI must be installed system-wide
		config = function()
			require("tree-sitter-manager").setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		event = { "BufReadPre", "BufNewFile" },

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				automatic_setup = true,
				ensure_installed = { "js" },
			})

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}

			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch TS file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}

			dapui.setup()

			dap.listeners.after.event_initialized["dapui"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "REPL" })
			vim.keymap.set("n", "<leader>dk", dap.terminate, { desc = "Kill" })
			vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI" })

			require("nvim-dap-virtual-text").setup()
		end,
	},
}

require("lazy").setup(plugins, {
	rocks = {
		enabled = false,
	},
})
