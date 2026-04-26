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

vim.keymap.set("n", "<leader>r", function()
  local word = vim.fn.expand("<cword>")
  local cmd = ":%s/\\<" .. word .. "\\>//gI"
  local keys = cmd .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3)
  vim.api.nvim_feedkeys(keys, "n", false)
end)

vim.keymap.set("v", "<leader>r", function()
  vim.cmd('noau normal! "vy')
  local text = vim.fn.getreg("v")
  local escaped_text = vim.fn.escape(text, "\\/.*$^~[]")
  local cmd = ":%s/" .. escaped_text .. "//gI"
  local keys = cmd .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3)
  vim.api.nvim_feedkeys(keys, "n", false)
end)

vim.keymap.set("n", "<leader>bs", function()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end, { desc = "Scratch Buffer" })

-- Search for a symbol across your whole project using FZF
vim.keymap.set('n', '<leader>vws', function() require('fzf-lua').lsp_live_workspace_symbols() end, opts)

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
