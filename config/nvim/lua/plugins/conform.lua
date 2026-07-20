return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format Code",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Neovim configs
        lua = { "stylua" },

        -- Next.js / React frontend (Powered by Biome!)
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },

        -- Markup/Config fallback (Prettier)
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- .NET backend
        cs = { "csharpier" },

        -- Infrastructure
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
