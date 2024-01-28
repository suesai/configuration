-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local map = Util.safe_keymap_set

map("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase window width" })

map("n", "<leader>hs", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch header and source" })

