local fd = vim.loop.fs_scandir(vim.fn.stdpath('config') .. '/lua/lsp/')
for name in
  function() return vim.loop.fs_scandir_next(fd) end
  do require('lsp.' .. name:gsub('.lua\z', '')) end
