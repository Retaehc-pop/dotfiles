-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- move line up/down
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- indentation
map("v", "<tab>", ">gv")
map("v", "<S-tab>", "<gv")

-- duplicate
map({ "n", "i" }, "<C-d>", "<esc>yyp", { desc = "duplicate line" })

--  undo
map({ "n", "i" }, "<C-z>", "<esc>ua", { desc = "undo" })

--map({ "i" }, "<c-/>", "<esc>gcc", { desc = "comment" })
