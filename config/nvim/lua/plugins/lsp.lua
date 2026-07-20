return {
  -- 1. Mason (Core Package Manager)
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ui = {
        icons = {
          package_pending = "➜",
          package_uninstalled = "✗",
          package_installed = "✓",
        }
      }
    }
  },

  -- 2. Mason Tool Installer (Auto-installs Formatters, Linters, & Debuggers)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "ansible-lint",
        "csharpier",
        "dotenv-linter",
        "trivy",
        "terraform",
        "terraform-ls",
        "prettier",
      },
    },
  },

  -- 3. Mason LSPConfig (Auto-installs Language Servers)
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "bashls",
        "biome",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "gopls",
        "html",
        "lua_ls",
        "prismals",
        "rust_analyzer",
        "tailwindcss",
        "terraformls",
        "ts_ls",
        "yamlls",
      },
    },
  },

  -- 4. LSPConfig (Wires everything up to Neovim)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "mason-org/mason-lspconfig.nvim", "saghen/blink.cmp" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("terraformls", {
        settings = {
          terraform = {
            ignoreSingleFileWarning = true,
          },
        },
      })

      vim.lsp.config("*", {
        capabilities = capabilities,
      })
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
          end

          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<leader>crn", vim.lsp.buf.rename, "Rename Variable/Function")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cd", vim.diagnostic.open_float, "Show Line Diagnostics")
        end,
      })
    end,
  },
}
