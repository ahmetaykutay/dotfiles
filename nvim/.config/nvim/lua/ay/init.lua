require('ay.lazy')
require('ay.remap')
require('ay.settings')

vim.cmd.colorscheme "catppuccin-macchiato"

-- This makes the Enter key actually open the file in the Quickfix window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = true, silent = true })
  end,
})

