return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix", -- Keeps it as a compact vertical list on the right side
    delay = 300,
    icons = {
      mappings = true,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      -- Auto-groups based on your newly organized namespaces
      { "<leader>c", group = "Code (Actions, Format, Rename)", icon = " " }, -- conform.lua, lsp.lua, snacks.lua
      { "<leader>d", group = "Debug (DAP)", icon = " " }, -- dap.lua
      { "<leader>f", group = "Find / File (Explorer, Search)", icon = " " }, -- snacks.lua
      { "<leader>g", group = "Git (Lazygit, Hunks, Blame)", icon = " " }, -- snacks.lua, gitsigns.lua
      { "<leader>n", group = ".NET (easy-dotnet)", icon = " " }, -- easy-dotnet.lua
      { "<leader>p", group = "Packages (NuGet)", icon = " " }, -- nuget.lua (Assuming you still have this)
      { "<leader>t", group = "Test (Neotest)", icon = " " }, -- neotest.lua, easy-dotnet.lua
      { "<leader>u", group = "UI / Notifications", icon = " " }, -- snacks.lua
      { "<leader>x", group = "Diagnostics & Trouble", icon = " " }, -- trouble.lua, snacks.lua
      { "<leader>b", group = "Buffers", icon = "󰓩 " },
      { "<leader>w", group = "Windows", icon = " " }, -- keymaps.lua (Equalize windows)
    })
  end,
}
