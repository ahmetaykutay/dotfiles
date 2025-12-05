local state = {
    buf = nil,
    last_buf = nil,
}

local function setup_terminal_buffer()
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        return state.buf
    end

    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, "[toggle-terminal]")
    vim.api.nvim_set_current_buf(buf)
    vim.fn.termopen(vim.o.shell)
    state.buf = buf

    return buf
end

local function toggle_terminal()
    local term_bufnr = setup_terminal_buffer()
    local current_bufnr = vim.api.nvim_win_get_buf(0)

    if current_bufnr == term_bufnr then
        if state.last_buf and vim.api.nvim_buf_is_valid(state.last_buf) then
            vim.api.nvim_set_current_buf(state.last_buf)
        end
    else
        state.last_buf = current_bufnr
        vim.api.nvim_set_current_buf(term_bufnr)
        vim.cmd("startinsert")
    end
end

vim.api.nvim_create_user_command('ToggleTerminal', function()
    toggle_terminal()
end, {})

vim.keymap.set("n", "<leader>t", toggle_terminal)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:ToggleTerminal<CR>', { noremap = true, silent = true })
