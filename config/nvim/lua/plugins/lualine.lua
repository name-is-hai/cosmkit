return {
  {
    "nvim-lualine/lualine.nvim",
    -- This dependency gives you the cool file icons (C#, TS, Docker, etc.)
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          -- Automatically matches whatever color theme you are using
          theme = "auto",
          -- Keeps one single status line at the bottom, even if you split your screen
          globalstatus = true,
          -- The powerline arrows for a sleek look
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          -- Left Side
          lualine_a = {
            "mode",
            { require("easy-dotnet.ui-modules.jobs").lualine }
          },                                               -- Shows NORMAL, INSERT, or VISUAL
          lualine_b = { "branch", "diff", "diagnostics" }, -- Your Git branch and any error counts
          lualine_c = { "filename" },                      -- The file you are currently editing

          -- Right Side
          lualine_x = {
            -- A custom block to show EXACTLY which Language Servers are running!
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                  return "No LSP"
                end
                local names = {}
                for _, client in ipairs(clients) do
                  table.insert(names, client.name)
                end
                return "  " .. table.concat(names, ", ")
              end,
              color = { fg = '#a6e3a1', gui = 'bold' }, -- A nice green color
            },
            "encoding",
            "filetype"
          },
          lualine_y = { "progress" }, -- What percentage of the file you are at
          lualine_z = { "location" }  -- Your exact Line and Column number
        },
      })
    end,
  }
}
