vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>Q", ":q<cr>")
vim.keymap.set("n", "<leader>q", ":bw<cr>")

vim.keymap.set("n", "<Leader>fo", ":lua vim.lsp.buf.format()<CR>")

vim.keymap.set("n", "<leader>i", ':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<CR>')

vim.api.nvim_set_keymap('n', '<leader>z', "<cmd>lua require'centerpad'.toggle{ leftpad = 30, rightpad = 20 }<cr>",
    { silent = true, noremap = true })

vim.keymap.set("n", "g.", ":FzfLua lsp_code_actions<cr>")
vim.keymap.set("x", "<leader>p", "\"_dp")

vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<C-p>', ':bp<CR>')

vim.keymap.set('n', '!', ':! ')

vim.keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('+', vim.fn.expand('%:.'))
end)

vim.keymap.set("n", "<leader>fp", function()
  print(vim.fn.expand("%:."))
end, { desc = "Show file path relative to cwd" })
