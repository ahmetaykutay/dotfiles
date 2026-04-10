local fzf = require('fzf-lua')

fzf.setup({
  files = {
    fd_opts = "--type f --hidden --no-ignore",
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore",
  }
})

local map = vim.keymap.set

local function get_current_dir()
    return vim.fn.expand('%:p:h')
end

map('n', '<leader>ff', function()
    fzf.files({ hidden = true })
end, { desc = "Fzf-lua Find Files (with hidden)" })
map('n', '<leader>fg', fzf.live_grep, { desc = "Fzf-lua Live Grep (Full project search)" })
map('n', '<leader>fb', fzf.buffers, { desc = "Fzf-lua Buffers" })
map('n', '<leader>fh', fzf.help_tags, { desc = "Fzf-lua Help Tags" })
map('n', '<leader>fp', fzf.git_files, { desc = "Fzf-lua Git Files" })
