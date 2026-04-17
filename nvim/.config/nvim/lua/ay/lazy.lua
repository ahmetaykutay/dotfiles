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
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "python",
                "rust",
                "typescript",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },

    -- 'theprimeagen/harpoon',
    'mbbill/undotree',

    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    {
        -- https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp",
        commit = "b356f2c",
        pin = true,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },

    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
        lazy = false,
    },

    "lukas-reineke/indent-blankline.nvim",

    {
        'prettier/vim-prettier',
        build = 'yarn install',
        ft = { 'javascript', 'typescript', 'css', 'less', 'scss', 'graphql', 'markdown', 'vue', 'html' }
    },

    { 'smithbm2316/centerpad.nvim' },

    { 'christoomey/vim-tmux-navigator' },

    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "nvim-mini/mini.icons" },
        ---@module "fzf-lua"
        ---@type fzf-lua.Config|{}
        ---@diagnostics disable: missing-fields
        opts = {},
        -- ** NEW CONFIGURATION HERE **
        config = function()
            local fzf = require("fzf-lua")

            -- This function registers fzf-lua to take over Neovim's default
            -- selection prompt (vim.ui.select), which LSP code actions use.
            fzf.register_ui_select()

            -- Optional: Add any specific setup options for fzf-lua here
            fzf.setup({})
        end
        ---@diagnostics enable: missing-fields
    },

    'm4xshen/autoclose.nvim',

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    }
}

require("lazy").setup(plugins, {})
