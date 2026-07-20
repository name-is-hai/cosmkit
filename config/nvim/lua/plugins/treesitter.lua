return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    branch = "master",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        sync_install = true,
        highlight = { enabled = true },
        indent = { enabled = true },
        ensure_installed = {
          "bash",
          "css",
          "html",
          "javascript",
          "json",
          "lua",
          "python",
          "typescript",
          "tsx",
          "vue",
          "yaml",
          "c_sharp",
          "rust",
          "csv",
          "dockerfile",
          "editorconfig",
          "json",
          "jsdoc",
          "jsonc",
          "markdown",
          "markdown_inline",
          "nginx",
          "proto",
          "sql",
          "toml",
          "ssh_config",
          "xml",
        },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- Allows you to use Ctrl+o to jump back to where you were
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup()
    end,
  },
  -- Auto-close HTML and React tags
  {
    "windwp/nvim-ts-autotag",
    -- This only needs to load when you actually open a file to edit
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        -- Enables auto-closing of tags
        enable_close = true,
        -- Enables auto-renaming of tags (change <div> to <span> and the </div> changes too!)
        enable_rename = true,
        -- Enables auto-closing of tags when you delete the opening tag
        enable_close_on_slash = true,
      },
      -- Optional: Only enable for specific languages to keep it light
      per_filetype = {
        ["html"] = { enable_close = true },
        ["xml"] = { enable_close = true },
        ["typescriptreact"] = { enable_close = true },
        ["javascriptreact"] = { enable_close = true },
        ["cs"] = { enable_close = true }, -- Helpful for Blazor/MAUI XML
      }
    },
  },
  -- Auto-close curly-brace, parentheses, brackets, and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      autopairs.setup({
        check_ts = true,
        -- This tells autopairs to stay out of the way of blink.cmp's popups
        enable_check_bracket_line = false,
      })

      -- Add a rule to handle the <CR> (Enter) expansion for {}
      autopairs.add_rules({
        Rule(" ", " ")
            :with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({ "()", "[]", "{}" }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({ "(  )", "[  ]", "{  }" }, context)
            end),
        Rule("%(.*%)%s*%=>%s*$", " {  }", { "typescript", "typescriptreact", "javascript" })
            :use_regex(true)
            :set_end_pair_length(2),
      })
    end,
  },
}
