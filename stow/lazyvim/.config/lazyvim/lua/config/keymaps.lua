-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Get vimrc functions
vim.cmd("source " .. os.getenv("HOME") .. "/.vimrc_common_funcs")

-- ================
-- Maps/Binds
-- ================

local map = vim.keymap.set

-- Misc
map({ "n" }, "<localleader>ml", ":call AppendModeline()<CR>", { noremap = true, silent = true })
map({ "i", "c" }, "<A-BS>", "<C-W>")
map("i", "<localleader>cp", "<Esc>:execute 'normal 0vg_\"+y'<CR>")

-- Use jk for esc to quickly exit insert
map("i", "jk", "<ESC>", { noremap = true })

-- abbreviations (and <c-b> for optional abbrevs)
map("i", "<c-b>", "<c-v><c-a><c-]>", { noremap = true })
vim.cmd('iabbrev date <c-r>=strftime("%F")<CR>')
vim.cmd("iabbrev program <Esc>mz:execute FileHeading()<CR>`z4j$A")
vim.cmd("iabbrev function <Esc>mz:execute FunctionHeading()<CR>`zj$A")

-- -- Unbind shift-j
-- map("n", "<s-j>", "j", { noremap = true })

-- Open snacks explorer with familiar <c-\>
map("n", "<c-\\>", ":lua Snacks.explorer()<CR>", { noremap = true, silent = true })

--  vim: set ts=2 sw=2 tw=0 et :
