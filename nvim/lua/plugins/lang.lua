return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      autoupdate_throttle = 50,
      max_parallel_requests = 32,
      -- popup = {
      --   border = cmp_window.bordered(),
      --   show_version_date = true,
      -- },
      completion = {
        crates = {
          enabled = true,
          max_results = 30,
        },
        cmp = {
          use_custom_kind = true,
        },
      },
      -- lsp = {
      --   enabled = true,
      --   on_attach = lsp_config.on_attach,
      --   actions = true,
      --   completion = true,
      --   hover = true,
      -- },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = {
      tools = {
        float_win_config = {
          border = "rounded",
        },
      },
      -- TODO: look at the keymap in the docs
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>ce", function()
            vim.cmd.RustLsp("explainError")
          end, { desc = "Rust Explain Error", buffer = bufnr })
          vim.keymap.set("n", "<leader>co", function()
            vim.cmd.RustLsp("openDocs")
          end, { desc = "Rust Open docs.rs Documentation", buffer = bufnr })
          vim.keymap.set("n", "<leader>cp", function()
            vim.cmd.RustLsp("parentModule")
          end, { desc = "Rust Parent Module", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}
