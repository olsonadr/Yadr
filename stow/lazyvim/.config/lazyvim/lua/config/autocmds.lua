-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- -- Function factory for opening specific URLs with a keyword
-- function OpenURLFactory(base_url)
--   return function()
--     local keyword = vim.fn.expand("<cword>")
--     local url = string.format(base_url, keyword)
--     vim.fn.jobstart({ "open", url }, { detach = true })
--   end
-- end

-- function OpenURL(base_url, keyword)
function OpenURL(args)
  -- Check whats in the args table
  local base_url = args["fargs"][1] or "https://www.google.com/search?q=%s"
  local keyword = args["fargs"][2] or vim.fn.expand("<cword>")
  local url = string.format(base_url, keyword)
  print("Opening URL: " .. url)
  vim.fn.jobstart({ "open", url }, { detach = true })
end
vim.api.nvim_create_user_command("OpenURL", OpenURL, { nargs = "*", desc = "Open URL with keyword" })

-- vim.api.nvim_create_user_command("OpenURL", function(opts)
--   OpenURL(opts.args)
-- end, { nargs = "?" })
--
-- vim.api.nvim_create_user_command("VG", function(args)
--   local vimCmd = "OpenURL"
--   if args["args"] then
--     vimCmd = vimCmd .. " " .. args["args"]
--   end
--   vim.cmd(vimCmd)
-- end, { desc = "Open Git vertically", nargs = "*" })

local keywordprg_mappings = {
  { prg = ":DefEng", patterns = { "markdown", "rst", "tex", "txt" } },
  { prg = ":Pydoc", patterns = { "python" } },
  { prg = ":help", patterns = { "vim", "help" } },
  { prg = ":OpenURL https://developer.mozilla.org/search?topic=api\\&topic=html\\&q=%s", patterns = { "html" } },
  { prg = ":OpenURL https://developer.mozilla.org/search?topic=api\\&topic=css\\&q=%s", patterns = { "css" } },
  { prg = ":OpenURL https://developer.mozilla.org/search?topic=api\\&topic=js\\&q=%s", patterns = { "javascript" } },
}

vim.api.nvim_create_augroup("custom_keywordprg", {})
for _, mapping in ipairs(keywordprg_mappings) do
  vim.api.nvim_create_autocmd("FileType", {
    group = "custom_keywordprg",
    pattern = mapping.patterns,
    callback = function()
      vim.opt_local.keywordprg = mapping.prg
    end,
  })
end

--  vim: set ts=8 sw=4 tw=80 et :
