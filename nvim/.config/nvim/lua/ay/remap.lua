vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("x", "<leader>p", "\"_dp")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>Q", ":q<cr>")
vim.keymap.set("n", "<leader>q", ":bw<cr>")

vim.keymap.set("n", "<leader>fp", ":Prettier<cr>")
vim.keymap.set("n", "<Leader>fo", ":lua vim.lsp.buf.format({formatting_options = { tabSize = 4, insertSpaces = true }})<CR>")

vim.keymap.set("n", "<leader>i",':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<CR>')

vim.api.nvim_set_keymap('n', '<leader>z', "<cmd>lua require'centerpad'.toggle{ leftpad = 30, rightpad = 20 }<cr>", { silent = true, noremap = true })

vim.keymap.set("n", "g.", ":CodeActionMenu<cr>")
vim.keymap.set("x", "<leader>p", "\"_dp")
