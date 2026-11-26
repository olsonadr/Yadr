-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Misc
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 79
vim.opt.colorcolumn = "80"
vim.opt.wrap = true
vim.opt.formatoptions:remove({ "c", "r", "o" })

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
elseif vim.env.TMUX and #vim.env.TMUX > 0 then
  vim.g.clipboard = "tmux"
elseif vim.env.XDG_SESSION_TYPE == "tty" then
  vim.g.clipboard = "OSC52"
elseif vim.env.WAYLAND_DISPLAY and #vim.env.WAYLAND_DISPLAY > 0 then
  vim.g.clipboard = "wl-copy"
elseif vim.env.DISPLAY and #vim.env.DISPLAY > 0 then
  vim.g.clipboard = "xclip"
end

-- Load global venv by default
-- vim.g.python3_host_prog = vim.fn.expand('~/.venv/bin/python3')

-- Disable scrollbar v2 mirgration message
vim.g.scrollbar_v2_notice = false

-- Disk-latency mitigations (see docs/DISK_LATENCY.md):
-- * 'fsync' off: every :w and every swap-file flush otherwise waits for a physical disk flush
--   (p99 ~ 1 s on the shared SWIS disk). 30 writes of a 200 KB file: 6-8 s -> 0.4 s. Data still reaches
--   the page cache and is written back by the kernel within seconds; only a host crash can lose it.
vim.opt.fsync = false
-- clangd logs every request at INFO (8 MB / 30k lines of lsp.log, rewritten constantly): keep WARN+
pcall(function()
  if vim.lsp.log and vim.lsp.log.set_level then vim.lsp.log.set_level("WARN") else vim.lsp.set_log_level("WARN") end
end)

--  vim: set ts=8 sw=4 tw=80 et :
