-- local function get_root_dir(fname)
--   -- If no root directory is found, default to the directory of the current file
--   if root then
--     return root
--   else
--     return vim.fn.getcwd()
--   end
-- end

return {
  {
    "neovim/nvim-lspconfig",
    -- init = function()
    --   local keys = require("lazyvim.plugins.lsp.keymaps").get()
    --   -- change a keymap
    --   keys[#keys + 1] = { "<leader>cc", false }
    --   keys[#keys + 1] = {
    --     "gl",
    --     function()
    --       vim.diagnostic.config({
    --         float = { border = "rounded" },
    --       })
    --       local float = vim.diagnostic.config().float
    --
    --       if float then
    --         local config = type(float) == "table" and float or {}
    --         config.scope = "line"
    --
    --         vim.diagnostic.open_float(config)
    --       end
    --     end,
    --     desc = "Line Diagnostics",
    --   }
    -- end,
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
          eslint = {
            settings = {
              -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
              workingDirectories = { mode = "auto" },
            },
          },
        },
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac", -- AutoTools
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            ".git",
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
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
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
        tailwindcss = function(_, opts)
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, vim.lsp.config.tailwindcss.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      -- keep your existing snacks opts, just make sure terminal is enabled
      terminal = {
        win = { style = "terminal" },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      local Snacks = require("snacks")

      -- one mapping for both C and C++
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function(ev)
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.write()

            local ft = vim.bo[ev.buf].filetype
            local file = vim.fn.expand("%:p")
            local output = vim.fn.expand("%:p:r")

            local compiler
            local flags = ""

            if ft == "c" then
              compiler = "gcc"
              flags = "-Wall -Wextra -std=c11"
            else
              compiler = "g++"
              flags = "-Wall -Wextra -std=c++20"
            end

            local cmd = string.format(
              '%s %s "%s" -o "%s" && "%s"; echo ""; echo "Press ENTER to close..."',
              compiler,
              flags,
              file,
              output,
              output
            )

            Snacks.terminal.open({ vim.o.shell, "-c", cmd }, {
              cwd = vim.fn.getcwd(),
              interactive = true,
              auto_close = false,
              start_insert = true,
              auto_insert = true,
            })
          end, { buffer = ev.buf, desc = "Compile & run C/C++ (Snacks term)" })
        end,
      })
    end,
  },
}
