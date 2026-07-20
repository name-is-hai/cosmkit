return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  keys = {
    -- Changed to <leader>n namespace (.NET)
    { "<leader>ntt", function() require("easy-dotnet").testrunner() end,             desc = "Dotnet: Open Test Runner" },
    { "<leader>np",  function() require("easy-dotnet").project_view() end,           desc = "Dotnet: Project View" },
    { "<leader>nb",  function() require("easy-dotnet").build_default_quickfix() end, desc = "Dotnet: Build Solution" },
    { "<leader>ns",  function() require("easy-dotnet").secrets() end,                desc = "Dotnet: User Secrets" },
    { "<leader>nr",  function() require("easy-dotnet").run_default() end,            desc = "Dotnet: Run Default Project" },
    { "<leader>nd",  function() require("easy-dotnet").debug_default() end,          desc = "Dotnet: Debug Default Project" },
  },
  config = function()
    require("easy-dotnet").setup({
      picker = "snacks",
      debugger = {
        auto_register_dap = true,
      },
      background_scanning = true,
      test_runner = {
        viewmode = "float",
        auto_start_testrunner = true,
        mappings = {
          -- Kept as <leader>t because this only attaches to C# files
          run_test_from_buffer = { lhs = "<leader>ntr", desc = "run test from buffer" },
          debug_test_from_buffer = { lhs = "<leader>ntd", desc = "debug test from buffer" },
          peek_stack_trace_from_buffer = { lhs = "<leader>ntp", desc = "peek stack trace from buffer" },
        }
      },
      lsp = { enabled = true, preload_roslyn = true, roslynator_enabled = true, easy_dotnet_analyzer_enabled = true }
    })
  end
}
