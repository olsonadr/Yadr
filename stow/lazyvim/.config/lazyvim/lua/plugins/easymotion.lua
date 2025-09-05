
-- Disable diagnostics when easymotion is active
vim.api.nvim_create_autocmd("User", {pattern = {"EasyMotionPromptBegin"}, callback = function() vim.diagnostic.enable(false) end})
function check_easymotion()
  local timer = vim.loop.new_timer()
  timer:start(500, 0, vim.schedule_wrap(function()
    -- vim.notify("check_easymotion")
    if vim.fn["EasyMotion#is_active"]() == 0 then
      vim.diagnostic.enable()
      vim.g.waiting_for_easy_motion = false
    else
      check_easymotion()
    end
  end))
end
vim.api.nvim_create_autocmd("User", {
  pattern = "EasyMotionPromptEnd",
  callback = function()
    if vim.g.waiting_for_easy_motion then return end
    vim.g.waiting_for_easy_motion = true
    check_easymotion()
  end
})

return {
-- add easymotion with config function
    {
        "easymotion/vim-easymotion",
        config = function()
            -- Enable EasyMotion
            vim.g.EasyMotion_do_mapping = 0  -- Disable default mappings
            -- Custom key mappings
            vim.api.nvim_set_keymap('n', '<Leader>j', '<Plug>(easymotion-j)', {})
            vim.api.nvim_set_keymap('n', '<Leader>k', '<Plug>(easymotion-k)', {})
        end,
    }
}

--  vim: set ts=8 sw=4 tw=80 et :
