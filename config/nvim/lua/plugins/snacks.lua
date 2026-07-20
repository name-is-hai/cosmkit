return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Performance
      bigfile = { enabled = true },
      quickfile = { enabled = true },

      -- UI & Visuals
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
        timeout = 5000
      },
      image = { enabled = true },
      indent = {
        animate = {
          enabled = false,
        },
        indent = {
          enabled = true,
          char = "▏",
          hl = "LineNr",
          only_scope = false,
          only_current = true,
        },
        scope = {
          enabled = true,
          char = "▏",
          underline = false,
          hl = "Function",
        },
        chunk = {
          enabled = false,
        },
      },
      scope = { enabled = true, },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            -- hidden = true,
            win = {
              list = {
                keys = {
                  ["A"] = "explorer_add_dotnet",
                },
              },
            },
            actions = {
              explorer_add_dotnet = function(picker)
                local dir = picker:dir()
                local easydotnet = require("easy-dotnet")

                easydotnet.create_new_item(dir, function(item_path)
                  local tree = require("snacks.explorer.tree")
                  local actions = require("snacks.explorer.actions")
                  tree:open(dir)
                  tree:refresh(dir)
                  actions.update(picker, { target = item_path })
                  picker:focus()
                end)
              end,
            },
          },
          -- files = {
          --   hidden = true,
          -- },
        },
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = {
          open = false, git_hl = false,
        },
        git = {
          patterns = { "GitSign" },
        },
      },
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader>,",  function() Snacks.picker.buffers() end,             desc = "Find Buffers" },
      { "<leader>/",  function() Snacks.picker.grep() end,                desc = "Find Grep (Search Text)" },
      { "<leader>:",  function() Snacks.picker.command_history() end,     desc = "Command History" },
      { "<leader>e",  function() Snacks.explorer() end,                   desc = "File Explorer" },

      -- Find (<leader>f...)
      { "<leader>ff", function() Snacks.picker.files() end,               desc = "Find Files" },
      { "<leader>fp", function() Snacks.picker.projects() end,            desc = "Find Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end,              desc = "Find Recent" },

      -- Search Mappings (<leader>s...)
      { "<leader>sk", function() Snacks.picker.keymaps() end,             desc = "Search Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end,             desc = "Search Location List" },
      { "<leader>sq", function() Snacks.picker.qflist() end,              desc = "Search Quickfix List" },
      { "<leader>sb", function() Snacks.picker.grep_buffers() end,        desc = "Search Open Buffers" },
      { "<leader>sD", function() Snacks.picker.diagnostics() end,         desc = "Search Diagnostics" },
      { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end,  desc = "Search Buffer Diagnostics" },

      -- Git & Terminal (<leader>g...)
      { "<leader>gg", function() Snacks.lazygit() end,                    desc = "Lazygit" },
      { "<leader>gd", function() Snacks.picker.git_diff() end,            desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end,        desc = "Git Log File" },
      { "<c-/>",      function() Snacks.terminal() end,                   mode = { "n", "t" },               desc = "Toggle Terminal" },

      -- LSP Navigation & Code (<leader>c...)
      { "gi",         function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gd",         function() Snacks.picker.lsp_definitions() end,     desc = "Goto Definition" },
      { "gr",         function() Snacks.picker.lsp_references() end,      nowait = true,                     desc = "References" },
      { "<leader>rf", function() Snacks.rename.rename_file() end,         desc = "Rename File via LSP" },

      -- UI & Notifications (<leader>u...)
      { "<leader>un", function() Snacks.notifier.hide() end,              desc = "Dismiss All Notifications" },
      { "<leader>uh", function() Snacks.notifier.show_history() end,      desc = "Notification History" },
    },
  },
}
