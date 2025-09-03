-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Misc
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80
vim.opt.wrap = true

-- Disable autoformat by default
vim.g.autoformat = false
vim.g.snacks_animate = false

-- Change whitespace chars
vim.opt.listchars = {
  tab = "> ",
  trail = " ",
  nbsp = "+",
}

-- Fix clipboard depending on runtime (WSL/X/Wayland)
if vim.fn.system("uname -r"):lower():find("microsoft") then
  vim.api.nvim_create_augroup("Yank", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = "Yank",
    pattern = "*",
    callback = function()
      vim.fn.system("clip.exe", vim.fn.getreg('"'))
    end,
  })
-- elseif vim.env.XDG_SESSION_TYPE == "tty" then
--   vim.g.clipboard = "OSC52"
elseif #vim.env.TMUX > 0 then
  vim.g.clipboard = "tmux"
elseif #vim.env.DISPLAY > 0 then
  vim.g.clipboard = "xclip"
elseif #vim.env.WAYLAND_DISPLAY > 0 then
  vim.g.clipboard = "wl-copy"
end

--  vim: set ts=8 sw=4 tw=80 et :
