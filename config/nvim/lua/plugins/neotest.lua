return {
  "nvim-neotest/neotest",
  cond = function()
    -- Scan upwards from the current directory looking for .NET project files
    local dotnet_files = vim.fs.find(function(name, path)
      return name:match("%.sln$") or name:match("%.csproj$") or name:match("%.fsproj$")
    end, { limit = 1, upward = true, path = vim.fn.getcwd() })

    -- If the list is empty (0), it's NOT a .NET project -> Return true (Load neotest)
    -- If it found a file (> 0), it IS a .NET project -> Return false (Do NOT load neotest)
    return #dotnet_files == 0
  end,
  -- Trigger loading when opening these file types OR pressing these keys
  ft = {
    -- "cs",
    "javascript",
    "typescript",
    "typescriptreact",
    "python"
  },

  -- Using your preferred lazy-loaded keys table structure
  keys = {
    -- Core Run Commands
    { "<leader>tr", function() require("neotest").run.run() end,                     desc = "Test: Run Nearest" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Test: Run File" },
    { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end,      desc = "Test: Run All in Project" },
    { "<leader>tx", function() require("neotest").run.stop() end,                    desc = "Test: Stop Nearest" },

    -- Summary & Output UI
    { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Test: Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Show Output" },
    { "<leader>tp", function() require("neotest").output_panel.toggle() end,         desc = "Test: Toggle Output Panel" },

    -- Watching
    { "<leader>tw", function() require("neotest").watch.watch() end,                 desc = "Test: Start Watching" },
    { "<leader>tW", function() require("neotest").watch.stop() end,                  desc = "Test: Stop Watching" },
  },

  -- Merged Dependencies
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    { "stevanfreeborn/neotest-playwright", branch = "fork" },
  },

  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-python"),
        require("neotest-jest"),
        require("neotest-vitest"),

        -- Advanced Playwright setup included
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            preset = "headed",
            experimental = {
              telescope = {
                enabled = true,
              },
            },
            get_playwright_binary = function()
              return vim.loop.cwd() .. "/node_modules/.bin/playwright"
            end,
          },
        }),
      },

      -- UI Settings from your original file
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        enabled = true,
        open = function()
          vim.cmd("copen")
        end,
      },
    })
  end,
}
