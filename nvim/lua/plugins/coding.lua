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
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    -- Not all LSP servers add brackets when completing a function.
    -- To better deal with this, LazyVim adds a custom option to cmp,
    -- that you can configure. For example:
    --
    -- ```lua
    -- opts = {
    --   auto_brackets = { "python" }
    -- }
    -- ```
    opts = function()
      -- Register nvim-cmp lsp capabilities
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local auto_select = true
      local defaults = require("cmp.config.default")()
      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
          ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<tab>"] = function(fallback)
            return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
          end,
        }),
        sources = cmp.config.sources({
          { name = "lazydev" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(entry, item)
            local icons = LazyVim.config.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end,
        },
        experimental = {
          -- only show ghost text when we show ai completions
          ghost_text = vim.g.ai_cmp and {
            hl_group = "CmpGhostText",
          } or false,
        },
        sorting = defaults.sorting,
      }
    end,
    main = "lazyvim.util.cmp",
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     {
  --       "Saecki/crates.nvim",
  --       event = { "BufRead Cargo.toml" },
  --       opts = {
  --         completion = {
  --           cmp = {
  --             enabled = true,
  --           },
  --         },
  --       },
  --     },
  --     -- {
  --     --   "zbirenbaum/copilot-cmp",
  --     --   dependencies = "copilot.lua",
  --     --   opts = {},
  --     --   config = function(_, opts)
  --     --     local copilot_cmp = require("copilot_cmp")
  --     --     copilot_cmp.setup(opts)
  --     --     -- attach cmp source whenever copilot attaches
  --     --     -- fixes lazy-loading issues with the copilot cmp source
  --     --     LazyVim.lsp.on_attach(function(client)
  --     --       if client.name == "copilot" then
  --     --         copilot_cmp._on_insert_enter({})
  --     --       end
  --     --     end)
  --     --   end,
  --     -- },
  --   },
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --     local cmp_window = require("cmp.config.window")
  --
  --     local M = {}
  --
  --     M.icons = {
  --       Class = " ",
  --       Color = " ",
  --       Constant = " ",
  --       Constructor = " ",
  --       Enum = " ",
  --       EnumMember = " ",
  --       Field = "󰄶 ",
  --       File = " ",
  --       Folder = " ",
  --       Function = " ",
  --       Interface = "󰜰",
  --       Keyword = "󰌆 ",
  --       Method = "ƒ ",
  --       Module = "󰏗 ",
  --       Property = " ",
  --       Snippet = "󰘍 ",
  --       Struct = " ",
  --       Text = " ",
  --       Unit = " ",
  --       Value = "󰎠 ",
  --       Variable = " ",
  --
  --       Namespace = "",
  --       Package = "",
  --       String = "",
  --       Number = "",
  --       Boolean = "",
  --       Array = "",
  --       Object = "",
  --       Key = "",
  --       Null = "",
  --       Event = "",
  --       Operator = "",
  --       TypeParameter = "",
  --       -- unique to CompletionIntemKind
  --       Reference = "",
  --       -- Codeium = require("lazyvim.config").icons.kinds.Codeium,
  --       -- Copilot = require("lazyvim.config").icons.kinds.Copilot,
  --     }
  --
  --     opts.sources = opts.sources or {}
  --
  --     -- table.insert(opts.sources, { name = "crates" })
  --     -- table.insert(opts.sources, 1, {
  --     --   name = "copilot",
  --     --   group_index = 1,
  --     --   priority = 100,
  --     -- })
  --
  --     opts.formatting = {
  --       fields = { "kind", "abbr", "menu" },
  --       format = function(entry, vim_item)
  --         local maxwidth = 50
  --         local n = entry.source.name
  --
  --         if n == "nvim_lsp" then
  --           vim_item.menu = "[LSP]"
  --         elseif n == "nvim_lua" then
  --           vim_item.menu = "[nvim]"
  --         else
  --           vim_item.menu = string.format("[%s]", n)
  --         end
  --
  --         if maxwidth and #vim_item.abbr > maxwidth then
  --           local last = vim_item.kind == "Snippet" and "~" or ""
  --           vim_item.abbr = string.format("%s %s", string.sub(vim_item.abbr, 1, maxwidth), last)
  --         end
  --         vim_item.kind = M.icons[vim_item.kind]
  --
  --         return vim_item
  --       end,
  --     }
  --
  --     -- Config tailwindcss
  --     -- original LazyVim kind icon formatter
  --     local format_kinds = opts.formatting.format
  --     opts.formatting.format = function(entry, item)
  --       format_kinds(entry, item) -- add icons
  --       return require("tailwindcss-colorizer-cmp").formatter(entry, item)
  --     end
  --
  --     opts.mapping = cmp.mapping.preset.insert({
  --       ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  --       ["<C-d>"] = cmp.mapping.scroll_docs(4),
  --       ["<CR>"] = cmp.mapping.confirm({ select = true }),
  --       ["<C-Space>"] = function()
  --         if cmp.visible() then
  --           cmp.confirm({ select = true })
  --         else
  --           cmp.complete()
  --         end
  --       end,
  --       ["<C-c>"] = cmp.mapping.abort(),
  --     })
  --
  --     opts.window = {
  --       completion = cmp_window.bordered(),
  --       documentation = cmp_window.bordered(),
  --     }
  --   end,
  -- },
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
