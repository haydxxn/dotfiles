-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.number = false

-- disable clipboard when use 'd', 'x'
vim.opt.clipboard = ""

-- LSP Server to use for Python.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff_lsp"

-- Set to false to disable auto format
vim.g.lazyvim_eslint_auto_format = true
