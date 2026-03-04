return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        -- typeStyle = { italic = false },
        -- keywordStyle = { italic = false },
        colors = {
          -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {},
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          local theme = colors.theme
          return {
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            -- NormalFloat = { bg = "none" },
            -- FloatBorder = { bg = "none" },
            -- FloatTitle = { bg = "none" },
          }
        end,
        -- theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {
          -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "wave",
        },
      })
    end,
  },
  -- {
  --   "svrana/neosolarized.nvim",
  --   dependencies = { "tjdevries/colorbuddy.nvim" },
  -- },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- local dracula = require("dracula")
      -- local colors = {
      --   bg = "#22212C",
      --   bg_light = "#2E2B3B",
      --   bg_lighter = "#393649",
      --   fg = "#F8F8F2",
      --   selection = "#454158",
      --   comment = "#7970A9",
      --   red = "#FF9580",
      --   orange = "#FFCA80",
      --   yellow = "#FFFF80",
      --   green = "#8AFF80",
      --   purple = "#9580FF",
      --   cyan = "#80FFEA",
      --   pink = "#FF80BF",
      --   bright_red = "#FF6E6E",
      --   bright_green = "#69FF94",
      --   bright_yellow = "#FFFFA5",
      --   bright_blue = "#D6ACFF",
      --   bright_magenta = "#FF92DF",
      --   bright_cyan = "#A4FFFF",
      --   bright_white = "#FFFFFF",
      --   menu = "#21222C",
      --   visual = "#3E4452",
      --   gutter_fg = "#4B5263",
      --   nontext = "#3B4048",
      -- }
      --
      -- dracula.setup({
      --   -- customize dracula color palette
      --   colors = colors,
      --   -- show the '~' characters after the end of buffers
      --   show_end_of_buffer = false, -- default false
      --   -- use transparent background
      --   transparent_bg = false, -- default false
      --   -- set custom lualine background color
      --   lualine_bg_color = "#44475a", -- default nil
      --   -- set italic comment
      --   italic_comment = false, -- default false
      --   -- overrides the default highlights see `:h synIDattr`
      --   overrides = {
      --     -- https://github.com/Mofiqul/dracula.nvim/blob/main/lua/dracula/groups.lua
      --     Comment = { fg = colors.comment, italic = false },
      --     Constant = { fg = colors.yellow, italic = false },
      --     Keyword = { fg = colors.cyan, italic = false },
      --     DiagnosticUnderlineError = { fg = colors.red, italic = true, underline = true },
      --     Special = { fg = colors.green },
      --     ["@keyword"] = { fg = colors.pink, italic = false },
      --     ["@keyword.function"] = { fg = colors.pink },
      --     ["@keyword.conditional"] = { fg = colors.pink, italic = false },
      --     ["@variable.member"] = { fg = colors.purple },
      --     ["@variable.parameter"] = { fg = colors.orange, italic = false },
      --     ["@constant"] = { fg = colors.purple, italic = false },
      --     ["@type"] = { fg = colors.bright_cyan, italic = false },
      --     ["@number"] = { fg = colors.purple, italic = false },
      --     ["@lsp.type.parameter"] = { fg = colors.orange, italic = false },
      --     NvimTreeNormal = { fg = colors.fg, bg = colors.bg_light },
      --     -- CmpItemAbbr = { fg = colors.white, bg = colors.bg_light },
      --     -- CmpItemKind = { fg = colors.white, bg = colors.bg_light },
      --     NormalFloat = { fg = colors.fg, bg = colors.bg_light },
      --     TelescopeNormal = { fg = colors.fg, bg = colors.bg_light },
      --     TelescopePromptBorder = { fg = colors.cyan },
      --     TelescopeResultsBorder = { fg = colors.cyan },
      --     TelescopePreviewBorder = { fg = colors.cyan },
      --     FloatBorder = { fg = colors.cyan },
      --     VertSplit = { fg = colors.cyan },
      --     WinSeparator = { fg = colors.cyan },
      --   },
      -- })
    end,
  },
  -- {
  --   "maxmx03/solarized.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("solarized").setup({
  --       -- theme = "neo",
  --     })
  --   end,
  -- },
  -- { "joshdick/onedark.vim" },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-d>"
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-u>"
        end
      end, { silent = true, expr = true })

      opts.presets.lsp_doc_border = true
    end,
  },
  -- {
  --   "nvimdev/dashboard-nvim",
  --   event = "VimEnter",
  --   opts = function(_, opts)
  --     local version = vim.version()
  --     local header = {
  --       "           ⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡴⠖⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠲⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠙⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⣰⠋⠀⡆⢀⠀⠀⠀⢤⢾⣱⣜⣾⣧⣶⣶⣶⣿⣷⣷⣶⣦⣤⣄⡀⣼⣞⣆⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⣼⠃⠀⠀⡿⡏⡇⡄⢀⣼⣷⣿⣿⣿⣿⣿⣿⡿⠿⣿⡿⠿⠿⠿⠿⢿⣿⣿⣿⣢⡀⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⣰⡇⠀⠀⣤⠻⡽⣼⣿⣿⣿⣿⡿⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠷⢦⣀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⣿⠀⠀⠀⣌⢷⣿⣿⡿⠟⢋⡡⠀⠀⢀⣠⣤⣴⣶⣿⣿⣿⣿⣿⣷⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⣈⡙⠶⣤⡀⠀⠀",
  --       "⠀⠀⠀⠀⠀⣿⠀⠀⢦⣸⠛⠛⢁⡀⣀⣈⢀⣴⣾⣿⣿⣿⠏⣿⢿⣿⣿⣿⡏⠈⢻⣿⠿⣿⣶⣔⢿⣦⣠⣮⣽⠛⠀⠀⠙⢦⠀",
  --       "⠀⠀⠀⠀⠀⢿⠀⣠⠞⢩⣴⣿⡿⡿⣯⣷⣿⣿⣿⣿⣿⠏⢠⡿⢸⣿⣿⡟⠀⠀⠀⢻⡆⠘⣿⣿⣷⣝⠺⣿⣦⠀⠀⠀⠀⠀⢳",
  --       "⠀⠀⠀⠀⠀⣨⠟⠁⠐⢷⡹⠋⣰⣿⣿⣿⣿⣿⣿⣿⠏⠀⢸⠃⢸⣿⡟⠀⠀⠀⠀⠸⡇⠀⠘⣿⣿⣿⣷⣄⡁⠀⠀⠀⠀⠀⠈⡇",
  --       "⠀⠀⠀⣠⠞⠁⠀⠀⠀⠈⢀⣼⣿⣿⣿⣿⠏⢸⣿⠇⠀⠠⠏⠀⢸⠏⠀⠀⠀⠀⠀⠀⠇⠀⠀⢸⣿⣿⣏⠉⡉⡀⠀⠀⠀⠀⣰⡇",
  --       "⠀⠀⡼⠁⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⡟⠀⢸⡟⠀⠀⠀⠀⠘⡏⣀⣿⡒⡿⠀⠀⠀⣀⠀⠀⠈⣿⣿⣿⣧⣿⣿⡆⠀⠀⣠⠏",
  --       "⠀⣼⠃⠀⢀⣶⣖⡄⠀⣾⣿⣿⣿⣿⣿⠃⠀⢸⣛⣲⣦⣤⣤⣤⣴⡟⠙⣷⣤⣤⠴⠾⠥⣤⡀⠀⣿⣿⡿⠿⣿⣿⠃⢀⡴⠁⠀",
  --       "⢸⡇⠀⠀⣼⣸⣻⢀⢰⣿⣿⣿⣿⣿⣿⠀⠸⢿⣶⣶⣦⠶⠋⡼⠟⠀⠀⡏⠉⣟⠻⣿⠿⣋⠁⠀⣿⣿⣮⣨⡾⣣⡼⠋⠀⠀⠀",
  --       "⢸⡇⠀⠀⣿⣿⢸⡻⣸⣿⡟⣭⢿⣿⡽⠄⠀⠀⠀⠀⠀⠀⠀⣠⣶⡀⠀⢻⣲⡦⣉⡋⠙⠏⠀⢸⠋⣞⣹⠗⠋⠁⠀⠀⠀⠀⠀",
  --       "⠘⣇⠀⠀⢿⣾⣯⣝⠮⢹⣇⠇⣷⡹⣧⠀⠀⠀⠀⢀⡠⠚⠀⠀⠈⠁⠀⠘⠉⠀⠀⠙⢦⠀⠀⢸⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠘⣆⠈⡪⠽⣿⣽⠶⠚⠻⣮⣙⠳⢿⡄⠀⠀⠀⠋⠀⠀⢀⣠⠤⠤⠤⠤⢄⣀⠀⠀⠈⠇⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠘⢶⣍⢻⠒⢺⠾⠩⠽⡇⣈⣙⣶⣷⡀⠀⠀⢀⡤⠚⠉⢀⣤⢴⢶⣤⣄⠉⠙⠲⢤⡀⢠⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠈⠉⠋⠉⠉⠉⠉⠉⠀⠀⠀⠈⠻⣦⣀⡉⢀⡠⠞⠉⢠⠏⠘⡄⠻⡍⠲⢦⣤⠷⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⡶⣤⣤⣄⣀⣤⣥⣤⣶⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡏⠛⠿⢿⣿⣿⡿⣿⡃⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⠇⠀⠀⠀⠉⢻⣿⣿⣣⢿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --       "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣴⣶⣿⣿⣯⠀⠀⠀⠀⠀⠀⠘⠛⠋⠈⠋⠙⣿⣷⣦⣤⣤⡀⠀⠀       ",
  --       "                                                                    ",
  --       "N E O V I M - v " .. version.major .. "." .. version.minor,
  --       "",
  --     }
  --
  --     opts.config.header = header
  --   end,
  -- },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   enabled = false,
  -- },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.g.lualine_laststatus = vim.o.laststatus
  --     if vim.fn.argc(-1) > 0 then
  --       -- set an empty statusline till lualine loads
  --       vim.o.statusline = " "
  --     else
  --       -- hide the statusline on the starter page
  --       vim.o.laststatus = 0
  --     end
  --   end,
  --   config = function()
  --     local status, lualine = pcall(require, "lualine")
  --     if not status then
  --       return
  --     end
  --
  --     local hide_in_width = function()
  --       return vim.fn.winwidth(0) > 80
  --     end
  --
  --     local diagnostics = {
  --       "diagnostics",
  --       sources = { "nvim_diagnostic" },
  --       sections = { "error", "warn" },
  --       symbols = { error = " ", warn = " " },
  --       -- colored = false,
  --       -- always_visible = true,
  --     }
  --
  --     local diff = {
  --       "diff",
  --       -- colored = false,
  --       symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  --       cond = hide_in_width,
  --     }
  --
  --     local filename = {
  --       "filename",
  --       path = 1,
  --     }
  --
  --     local filetype = {
  --       "filetype",
  --       icons_enabled = false,
  --     }
  --
  --     local location = {
  --       "location",
  --       padding = 0,
  --     }
  --
  --     lualine.setup({
  --       options = {
  --         globalstatus = true,
  --         icons_enabled = true,
  --         theme = "auto",
  --         component_separators = { left = "", right = "" },
  --         section_separators = { left = "", right = "" },
  --         disabled_filetypes = { "alpha", "dashboard" },
  --         always_divide_middle = true,
  --       },
  --       sections = {
  --         lualine_a = { "mode" },
  --         lualine_b = { "branch" },
  --         lualine_c = { diagnostics },
  --         lualine_x = { diff, filename, filetype },
  --         lualine_y = { location },
  --         lualine_z = { "progress" },
  --       },
  --     })
  --   end,
  -- },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      options = {
        right = { size = 70 },
        left = { size = 35 },
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5 },
        },
        {
          title = "Neo-Tree Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = false,
          collapsed = true, -- show window as closed/collapsed on start
          open = "Neotree position=right git_status",
        },
        {
          title = "Neo-Tree Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
          pinned = false,
          collapsed = true, -- show window as closed/collapsed on start
          open = "Neotree position=top buffers",
        },
        {
          title = function()
            local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
            return vim.fn.fnamemodify(buf_name, ":t")
          end,
          ft = "Outline",
          pinned = false,
          open = "SymbolsOutlineOpen",
        },
        -- any other neo-tree windows
        "neo-tree",
      },
      animate = {
        enabled = false,
      },
    },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("solarized-osaka").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors) end,

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors) end,
      })
    end,
  },
  -- { "echasnovski/mini.icons", version = false, enabled = false },
}
