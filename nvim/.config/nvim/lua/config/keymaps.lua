-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<S-j>", ":m .+1<CR>==") -- move line up(n)
map("n", "<S-k>", ":m .-2<CR>==") -- move line down(n)
map("v", "<S-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
map("v", "<S-k>", ":m '<-2<CR>gv=gv") -- move line down(v)
