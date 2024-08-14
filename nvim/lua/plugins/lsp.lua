local function get_root_dir(fname)
  -- Attempt to find the nearest Package.swift or .git directory
  local root = vim.fs.dirname(vim.fs.find({ "Package.swift", ".git" }, { upward = true, path = fname })[1])

  -- If no root directory is found, default to the directory of the current file
  if root then
    return root
  else
    return vim.fn.getcwd()
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "<leader>cc", false }
      keys[#keys + 1] = {
        "gl",
        function()
          vim.diagnostic.config({
            float = { border = "rounded" },
          })
          local float = vim.diagnostic.config().float

          if float then
            local config = type(float) == "table" and float or {}
            config.scope = "line"

            vim.diagnostic.open_float(config)
          end
        end,
        desc = "Line Diagnostics",
      }
    end,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
        sourcekit = {
          cmd = {
            "sourcekit-lsp",
          },
          filetypes = { "swift" },
          root_dir = function(fname)
            return get_root_dir(fname)
          end,
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
        tailwindcss = function(_, opts)
          local tw = require("lspconfig.server_configurations.tailwindcss")
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Additional settings for Phoenix projects
          opts.settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          }

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
}
