-- Leader keys have to be set before lazy.nvim loads any plugin.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
-- One fixed-width, right-aligned number column: the current line's absolute
-- number would otherwise sit left-aligned while the relative ones sit right,
-- so the column looked indented and shifted from line to line. Wrapped
-- continuation lines get no number.
vim.opt.numberwidth = 4
vim.opt.statuscolumn = "%s%=%{v:virtnum ? '' : (v:relnum ? v:relnum : v:lnum)} "
vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true

-- Keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left, keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right, keep selection" })
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Plugins (lazy.nvim)" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Flash the yanked text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Could not clone lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins live in lua/plugins/*.lua. Versions are pinned in lazy-lock.json
-- next to this file; `:Lazy update` moves them forward.
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "one_monokai" } },
  rocks = { enabled = false }, -- no plugin here needs luarocks
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      reset = false, -- Keeps ~/.local/share/nvim/site/ in runtimepath
    },
  },
})
