local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex)
map("n", "<leader>u", vim.cmd.UndotreeToggle)

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

map("n", "<leader>w", ":w<cr>")
map("n", "<leader>Q", ":q<cr>")
map("n", "<leader>q", ":bw<cr>")

map("n", "<Leader>fo", ":lua vim.lsp.buf.format()<CR>")

map("n", "<leader>i", ':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<CR>')

map(
	"n",
	"<leader>z",
	"<cmd>lua require'centerpad'.toggle{ leftpad = 30, rightpad = 20 }<cr>",
	{ silent = true, noremap = true }
)

map("x", "<leader>p", '"_dp')

map("n", "<leader>e", ":Oil<CR>")
map("n", "<C-p>", ":bp<CR>")

map("n", "!", ":! ")

map("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:."))
end)

map("n", "<leader>cP", function()
	print(vim.fn.expand("%:."))
end, { desc = "Show file path relative to cwd" })

map("n", "<leader>r", function()
	local word = vim.fn.expand("<cword>")
	local cmd = ":%s/\\<" .. word .. "\\>//gI"
	local keys = cmd .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

map("v", "<leader>r", function()
	vim.cmd('noau normal! "vy')
	local text = vim.fn.getreg("v")
	local escaped_text = vim.fn.escape(text, "\\/.*$^~[]")
	local cmd = ":%s/" .. escaped_text .. "//gI"
	local keys = cmd .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

map("n", "<leader>bs", function()
	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "hide"
	vim.bo.swapfile = false
end, { desc = "Scratch Buffer" })

-- Search for a symbol across your whole project using FZF
map("n", "<leader>vws", function()
	require("fzf-lua").lsp_live_workspace_symbols()
end)

map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
