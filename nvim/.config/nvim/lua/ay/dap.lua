local dap = require("dap")
local dapui = require("dapui")

local map = function(keys, func, desc)
	vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "Lsp: " .. desc })
end

map("<leader>db", dap.toggle_breakpoint, "Toggle Break")
map("<leader>dc", dap.continue, "Continue")
map("<leader>dr", dap.repl.open, "Inspect")
map("<leader>dk", dap.terminate, "Kill")
map("<leader>dso", dap.step_over, "Step Over")
map("<leader>dsi", dap.step_into, "Step Into")
map("<leader>dsu", dap.step_out, "Step Out")
map("<leader>dl", dap.run_last, "Run Last")
map("<leader>duu", dapui.open, "open ui")
map("<leader>duc", dapui.close, "open ui")
