return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text", -- Added back for inline variable values
  },
  -- 1. VS Code Style Keymaps
  keys = {
    { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
    { "<S-F5>",     function() require("dap").terminate() end,         desc = "Debug: Stop/Terminate" },
    { "<C-S-F5>",   function() require("dap").restart() end,           desc = "Debug: Restart" },
    { "<F9>",       function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
    { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
    { "<S-F11>",    function() require("dap").step_out() end,          desc = "Debug: Step Out" },

    -- Extra Utility Keys
    { "<leader>dc", function() require("dap").clear_breakpoints() end, desc = "Debug: Clear Breakpoints" },
    { "<leader>dl", function() require("dap").list_breakpoints() end,  desc = "Debug: List Breakpoints" },
    { "<leader>du", function() require("dapui").toggle() end,          desc = "Debug: Toggle UI Panels" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    vim.env.DOTNET_ROLL_FORWARD = "Major"
    dap.defaults.fallback.exception_breakpoints = {}

    -- 2. Visual Enhancements (Icons & Inline Text)
    require("nvim-dap-virtual-text").setup({ enabled = true })

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = 'DiagnosticError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '⚠️', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DiagnosticInfo', linehl = 'CursorLine', numhl = '' })

    -- 3. UI Setup
    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = { disconnect = "", pause = "", play = "", run_last = "", step_back = "", step_into = "", step_out = "", step_over = "", terminate = "" },
      },
      element_mappings = {},
      expand_lines = true,
      floating = { border = "rounded", mappings = { close = { "q", "<Esc>" } } },
      force_buffers = true,
      icons = { collapsed = "", current_frame = "", expanded = "" },
      layouts = {
        { elements = { { id = "scopes", size = 0.25 }, { id = "breakpoints", size = 0.25 }, { id = "stacks", size = 0.25 }, { id = "watches", size = 0.25 } }, position = "right",  size = 50 },
        { elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },                                                                          position = "bottom", size = 10 },
      },
      mappings = { edit = "e", expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", repl = "r", toggle = "t" },
      render = { indent = 1, max_value_lines = 100 },
    })

    -- 4. JS/TS Adapters & Configurations
    for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
      local pwaType = "pwa-" .. adapterType
      dap.adapters[pwaType] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }
      dap.adapters[adapterType] = function(cb, config)
        local nativeAdapter = dap.adapters[pwaType]
        config.type = pwaType
        if type(nativeAdapter) == "function" then nativeAdapter(cb, config) else cb(nativeAdapter) end
      end
    end

    local enter_launch_url = function()
      local co = coroutine.running()
      return coroutine.create(function()
        vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
          if url == nil or url == "" then return else coroutine.resume(co, url) end
        end)
      end)
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
      dap.configurations[language] = {
        { type = "pwa-node",   request = "launch", name = "Launch file using Node.js",                       program = "${file}",                           cwd = "${workspaceFolder}" },
        { type = "pwa-node",   request = "attach", name = "Attach to process using Node.js",                 processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
        { type = "pwa-node",   request = "launch", name = "Launch file using Node.js with ts-node/register", program = "${file}",                           cwd = "${workspaceFolder}",     runtimeArgs = { "-r", "ts-node/register" } },
        { type = "pwa-chrome", request = "launch", name = "Launch Chrome",                                   url = enter_launch_url,                        webRoot = "${workspaceFolder}", sourceMaps = true },
        { type = "pwa-msedge", request = "launch", name = "Launch Edge",                                     url = enter_launch_url,                        webRoot = "${workspaceFolder}", sourceMaps = true },
      }
    end

    -- -- 5. C# / .NET Setup
    -- local mason_path = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
    -- dap.adapters.netcoredbg = {
    --   type = "executable",
    --   command = vim.loop.fs_stat(mason_path) and mason_path or "netcoredbg",
    --   args = { "--interpreter=vscode" },
    -- }
    --
    -- dap.configurations.cs = {
    --   {
    --     type = "netcoredbg",
    --     name = "Launch .NET (easy-dotnet)",
    --     request = "launch",
    --     env = function()
    --       local dll = require("easy-dotnet").get_debug_dll()
    --       -- Automatically reads your launchSettings.json environment variables!
    --       return require("easy-dotnet").get_environment_variables(dll.project_name, dll.project_path, true)
    --     end,
    --     program = function()
    --       -- Automatically finds the correct bin/Debug/net9.0/xxx.dll!
    --       return require("easy-dotnet").get_debug_dll().dll_path
    --     end,
    --     cwd = function()
    --       return require("easy-dotnet").get_debug_dll().project_path
    --     end,
    --   },
    -- }

    -- 7. UI Auto-Open/Close Logic
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
  end,
}
