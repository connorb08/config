return {
  -- Fuzzy finder, built on the fzf, ripgrep, fd and bat that mise installs
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Word under cursor" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Symbols" },
      { "<leader>f.", "<cmd>FzfLua resume<cr>", desc = "Resume last search" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
      { "<leader><leader>", "<cmd>FzfLua files<cr>", desc = "Files" },
      { "<leader>/", "<cmd>FzfLua blines<cr>", desc = "Search in buffer" },
    },
    opts = {},
  },

  -- File manager: yazi in a floating window
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>e", "<cmd>Yazi<cr>", desc = "File manager at this file" },
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "File manager at working directory" },
    },
    opts = {},
  },

  -- Git change markers in the sign column, hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buffer)
        local gitsigns = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end
        map("n", "]h", function() gitsigns.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gitsigns.nav_hunk("prev") end, "Previous hunk")
        map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
        map("n", "<leader>ga", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff this file")
      end,
    },
  },

  -- Closes brackets and quotes
  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },

  -- Add, delete and replace surroundings: sa, sd, sr
  { "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },

  -- Ctrl-h/j/k/l move between windows, and on into the next tmux pane at the
  -- edge (its tmux half is in dotfiles/tmux/tmux.conf). Outside tmux they just
  -- move between windows.
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window/pane left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window/pane down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window/pane up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window/pane right" },
    },
  },
}
