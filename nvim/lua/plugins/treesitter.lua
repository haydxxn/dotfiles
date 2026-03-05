return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = {
      disable = function(_, bufnr) -- Disable in large buffers
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end,
    },
    ensure_installed = {
      "rust",
      "scss",
      "bash",
      "help",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "c",
      "cpp",
    },
    ignore_install = { "help" },
    indent = { enable = true },
  },
}
