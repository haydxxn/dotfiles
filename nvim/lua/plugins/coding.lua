return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   opts = {
  --     suggestion = { enabled = true },
  --     panel = { enabled = false },
  --     filetypes = {
  --       rust = true,
  --       lua = true,
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   dependencies = "copilot.lua",
  --   opts = {},
  --   config = function(_, opts)
  --     local copilot_cmp = require("copilot_cmp")
  --     copilot_cmp.setup(opts)
  --     -- attach cmp source whenever copilot attaches
  --     -- fixes lazy-loading issues with the copilot cmp source
  --     LazyVim.lsp.on_attach(function(client)
  --       if client.name == "copilot" then
  --         copilot_cmp._on_insert_enter({})
  --       end
  --     end)
  --   end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          completion = {
            cmp = {
              enabled = true,
            },
          },
        },
      },
      -- {
      --   "zbirenbaum/copilot-cmp",
      --   dependencies = "copilot.lua",
      --   opts = {},
      --   config = function(_, opts)
      --     local copilot_cmp = require("copilot_cmp")
      --     copilot_cmp.setup(opts)
      --     -- attach cmp source whenever copilot attaches
      --     -- fixes lazy-loading issues with the copilot cmp source
      --     LazyVim.lsp.on_attach(function(client)
      --       if client.name == "copilot" then
      --         copilot_cmp._on_insert_enter({})
      --       end
      --     end)
      --   end,
      -- },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local cmp_window = require("cmp.config.window")

      local M = {}

      M.icons = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Field = "󰄶 ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = "󰜰",
        Keyword = "󰌆 ",
        Method = "ƒ ",
        Module = "󰏗 ",
        Property = " ",
        Snippet = "󰘍 ",
        Struct = " ",
        Text = " ",
        Unit = " ",
        Value = "󰎠 ",
        Variable = " ",

        Namespace = "",
        Package = "",
        String = "",
        Number = "",
        Boolean = "",
        Array = "",
        Object = "",
        Key = "",
        Null = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        -- unique to CompletionIntemKind
        Reference = "",
        -- Codeium = require("lazyvim.config").icons.kinds.Codeium,
        -- Copilot = require("lazyvim.config").icons.kinds.Copilot,
      }

      opts.sources = opts.sources or {}

      -- table.insert(opts.sources, { name = "crates" })
      -- table.insert(opts.sources, 1, {
      --   name = "copilot",
      --   group_index = 1,
      --   priority = 100,
      -- })

      opts.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local maxwidth = 50
          local n = entry.source.name

          if n == "nvim_lsp" then
            vim_item.menu = "[LSP]"
          elseif n == "nvim_lua" then
            vim_item.menu = "[nvim]"
          else
            vim_item.menu = string.format("[%s]", n)
          end

          if maxwidth and #vim_item.abbr > maxwidth then
            local last = vim_item.kind == "Snippet" and "~" or ""
            vim_item.abbr = string.format("%s %s", string.sub(vim_item.abbr, 1, maxwidth), last)
          end
          vim_item.kind = M.icons[vim_item.kind]

          return vim_item
        end,
      }

      -- Config tailwindcss
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end

      opts.mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = function()
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            cmp.complete()
          end
        end,
        ["<C-c>"] = cmp.mapping.abort(),
      })

      opts.window = {
        completion = cmp_window.bordered(),
        documentation = cmp_window.bordered(),
      }
    end,
  },
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
}
