local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', ":Telescope find_files hidden=true<cr>", {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ")});
end)

require("telescope").load_extension "file_browser"

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<leader>e",
  ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<cr>",
  { noremap = true }
)

