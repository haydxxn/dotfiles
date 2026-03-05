-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- move block code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor always at the middle screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste without replace word copied
vim.keymap.set("x", "<leader>p", '"_dp')

-- copy to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- disable some default LazyVim keymaps
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

-- vim.keymap.set("n", "<leader>rr", function()
--   vim.cmd.write()
--
--   local file = vim.fn.expand("%:p")
--   local output = vim.fn.expand("%:p:r")
--
--   -- Add flags here if you like: -Wall -Wextra -std=c11
--   local cmd = string.format('gcc "%s" -o "%s" && "%s"; echo ""; echo "Press ENTER to close..."', file, output, output)
--
--   -- Run via a shell, and do NOT auto-close
--   Snacks.terminal.open({ vim.o.shell, "-c", cmd }, {
--     cwd = vim.fn.getcwd(),
--     interactive = true, -- start in insert mode
--     auto_close = false, -- keep terminal open after command finishes
--     start_insert = true,
--     auto_insert = true,
--   })
-- end, { desc = "Compile & run C (Snacks term)" })

-- local function compile_and_run()
--   vim.cmd.write()
--
--   local ft = vim.bo.filetype
--   local file = vim.fn.expand("%:p")
--   local output = vim.fn.expand("%:p:r")
--
--   local compiler
--   local flags = ""
--
--   if ft == "c" then
--     compiler = "gcc"
--     -- add C flags if you like:
--     flags = "-Wall -Wextra -std=c11"
--   elseif ft == "cpp" or ft == "c++" then
--     compiler = "g++"
--     -- add C++ flags if you like:
--     flags = "-Wall -Wextra -std=c++20"
--   else
--     vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
--     return
--   end
--
--   local cmd = string.format(
--     '%s %s "%s" -o "%s" && "%s"; echo ""; echo "Press ENTER to close..."',
--     compiler,
--     flags,
--     file,
--     output,
--     output
--   )
--
--   Snacks.terminal.open({ vim.o.shell, "-c", cmd }, {
--     cwd = vim.fn.getcwd(),
--     interactive = true,
--     auto_close = false,
--     start_insert = true,
--     auto_insert = true,
--   })
-- end
--
-- vim.keymap.set("n", "<leader>rr", compile_and_run, {
--   desc = "Compile & run C/C++",
--   buffer = 0,
-- })
