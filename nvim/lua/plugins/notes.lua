local picker = "telescope.nvim"

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    name = "obsidian",
    lazy = true,
    ft = "markdown",
    -- event = {
    --   "BufReadPre " .. vim.fn.resolve(vim.fn.expand "~/Obsidian/notes") .. "/*",
    --   "BufNewFile " .. vim.fn.resolve(vim.fn.expand "~/Obsidian/notes") .. "/*",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-cmp",
      picker,
    },
    config = function(_, opts)
      -- Setup obsidian.nvim
      require("obsidian").setup(opts)

      -- Create which-key mappings for common commands.
      local wk = require("which-key")

      wk.register({
        ["<leader>o"] = {
          name = "Obsidian",
          o = { "<cmd>ObsidianOpen<cr>", "Open note" },
          d = { "<cmd>ObsidianDailies -10 0<cr>", "Daily notes" },
          p = { "<cmd>ObsidianPasteImg<cr>", "Paste image" },
          q = { "<cmd>ObsidianQuickSwitch<cr>", "Quick switch" },
          s = { "<cmd>ObsidianSearch<cr>", "Search" },
          t = { "<cmd>ObsidianTags<cr>", "Tags" },
          l = { "<cmd>ObsidianLinks<cr>", "Links" },
          b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
          m = { "<cmd>ObsidianTemplate<cr>", "Template" },
          n = { "<cmd>ObsidianQuickSwitch nav<cr>", "Nav" },
          r = { "<cmd>ObsidianRename<cr>", "Rename" },
          w = { "<cmd>ObsidianWorkspace<cr>", "Workspace" },
          c = {
            function()
              local day_of_week = os.date("%A")
              assert(type(day_of_week) == "string")

              ---@type integer
              local offset_start
              if day_of_week == "Sunday" then
                offset_start = 1
              elseif day_of_week == "Monday" then
                offset_start = 0
              elseif day_of_week == "Tuesday" then
                offset_start = -1
              elseif day_of_week == "Wednesday" then
                offset_start = -2
              elseif day_of_week == "Thursday" then
                offset_start = -3
              elseif day_of_week == "Friday" then
                offset_start = -4
              elseif day_of_week == "Saturday" then
                offset_start = 2
              end
              assert(offset_start)

              vim.cmd(string.format("ObsidianDailies %d %d", offset_start, offset_start + 4))
            end,
            "Current week",
          },
        },
      })

      wk.register({
        ["<leader>o"] = {
          name = "Obsidian",
          e = {
            function()
              local title = vim.fn.input({ prompt = "Enter title (optional): " })
              vim.cmd("ObsidianExtractNote " .. title)
            end,
            "Extract text into new note",
          },
          l = {
            function()
              vim.cmd("ObsidianLink")
            end,
            "Link text to an existing note",
          },
          n = {
            function()
              vim.cmd("ObsidianLinkNew")
            end,
            "Link text to a new note",
          },
        },
      }, {
        mode = "v",
      })
    end,
    opts = {
      workspaces = {
        {
          name = "notes",
          -- path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
          path = "~/Documents/Obsidian",
          -- path = "~/Obsidian/notes",
        },
        -- {
        --   name = "demo",
        --   path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/demo",
        --   overrides = {
        --     daily_notes = {
        --       date_format = "%Y-%m-%d",
        --       folder = "daily",
        --       -- template = "daily.md",
        --       alias_format = vim.NIL,
        --     },
        --     new_notes_location = "current_dir",
        --     notes_subdir = vim.NIL,
        --     -- disable_frontmatter = true,
        --   },
        -- },
        -- {
        --   name = "no-vault",
        --   path = function()
        --     return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        --   end,
        --   strict = true,
        --   overrides = {
        --     notes_subdir = vim.NIL,
        --     new_notes_location = "current_dir",
        --     templates = {
        --       subdir = vim.NIL,
        --     },
        --     disable_frontmatter = true,
        --   },
        -- },
      },

      notes_subdir = "notes",

      picker = {
        name = picker,
      },

      sort_by = "modified",
      sort_reversed = true,

      open_notes_in = "vsplit",

      log_level = vim.log.levels.INFO,

      -- disable_frontmatter = true,

      wiki_link_func = "prepend_note_id",
      -- wiki_link_func = "use_alias_only",
      -- wiki_link_func = "prepend_note_path",
      -- wiki_link_func = "use_path_only",

      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      image_name_func = function()
        ---@type obsidian.Client
        local client = require("obsidian").get_client()

        local note = client:current_note()
        if note then
          return string.format("%s-", note.id)
        else
          return string.format("%s-", os.time())
        end
      end,

      new_notes_location = "notes_subdir",

      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        substitutions = {},
      },

      daily_notes = {
        date_format = "%Y-%m-%d",
        folder = "notes/daily",
        alias_format = "%A %B %d, %Y",
        -- template = "nvim-daily.md",
      },

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      ---@param note obsidian.Note
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and vim.tbl_count(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        ---@param client obsidian.Client
        ---@diagnostic disable-next-line: unused-local
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        ---@diagnostic disable-next-line: unused-local
        enter_note = function(client, note)
          if note.path.stem == "nav" then
            vim.opt.wrap = false
          end
        end,

        -- Runs anytime you leave the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        ---@diagnostic disable-next-line: unused-local
        leave_note = function(client, note)
          vim.api.nvim_buf_call(note.bufnr or 0, function()
            vim.cmd("silent w")
          end)
        end,

        -- Runs right before writing the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        ---@diagnostic disable-next-line: unused-local
        pre_write_note = function(client, note) end,

        -- Runs anytime the workspace is set/changed.
        ---@param client obsidian.Client
        ---@param workspace obsidian.Workspace
        ---@diagnostic disable-next-line: unused-local
        post_set_workspace = function(client, workspace)
          -- TODO: make sure this only runs when we're inside a vault.
          -- client.log.info("Changing directory to %s", workspace.path)
          -- vim.cmd.cd(tostring(workspace.path))
        end,
      },

      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { order = 1, char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { order = 2, char = "", hl_group = "ObsidianDone" },
          [">"] = { order = 3, char = "", hl_group = "ObsidianRefText" },
          ["~"] = { order = 4, char = "", hl_group = "ObsidianTilde" },
          ["!"] = { order = 5, char = "", hl_group = "ObsidianRightArrow" },

          -- [" "] = { char = "•", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "•", hl_group = "ObsidianDone" },
          -- [">"] = { char = "•", hl_group = "ObsidianRightArrow" },
          -- ["~"] = { char = "•", hl_group = "ObsidianTilde" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#DCD7BA" },
          ObsidianDone = { bold = true, fg = "#98bb6c" },
          ObsidianRightArrow = { bold = true, fg = "#de9800" },
          ObsidianTilde = { bold = true, fg = "#ff5d62" },
          ObsidianBullet = { bold = true, fg = "#a3d4d5" },
          -- ObsidianRefText = { underline = true, fg = "#cc99ff" },
          -- ObsidianExtLinkIcon = { fg = "#cc99ff" },
          ObsidianRefText = { underline = true, fg = "#957fb8" },
          ObsidianExtLinkIcon = { fg = "#957fb8" },
          ObsidianTag = { italic = true, fg = "#a3d4d5" },
          ObsidianBlockID = { italic = true, fg = "#a3d4d5" },
          ObsidianHighlightText = { bg = "#E6C384" },
        },
      },
    },
  },
}
