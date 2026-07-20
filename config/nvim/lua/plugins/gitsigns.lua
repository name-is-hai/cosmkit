return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {

      signs                   = {
        add          = { text = "▎", hl = "GitSignsAdd" },
        change       = { text = "▎", hl = "GitSignsChange" },
        delete       = { text = "", hl = "GitSignsDelete" },
        topdelete    = { text = "", hl = "GitSignsDelete" },
        changedelete = { text = "▎", hl = "GitSignsChange" },
        untracked    = { text = "▎", hl = "GitSignsUntracked" },
      },

      current_line_blame      = true,

      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' - right after the line, 'right_align' - far right
        delay = 500,           -- Shows up after half a second of resting your cursor
      },

      -- Set up keybindings that only load when you are in a Git repository
      on_attach               = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- 1. Navigation
        map("n", "]h", gs.next_hunk, "Next Git hunk")
        map("n", "[h", gs.prev_hunk, "Previous Git hunk")

        -- 2. Actions (Moved to <leader>gh - Git Hunk)
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Git hunk")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage Git hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset Git hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage entire file")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset entire file")

        -- 3. Detailed Blame
        map("n", "<leader>gb", function() gs.blame_line { full = true } end, "Full Blame popup")
      end,
    },
  }
}
