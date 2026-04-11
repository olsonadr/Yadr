-- For customization of snacks plugin

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        ["<leader>ud"] = { name = " Diagnostics (Global)" },
        ["<leader>uD"] = { name = " Diagnostics (Buffer)" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        animate = {
          duration = { step = 10, total = 100 },
          easing = "linear",
        },
        -- faster animation while repeaing after delay
        animate_repeat = {
          delay = 50,
          duration = { step = 3, total = 20 },
          easing = "linear",
        },
      },
      -- dashboard
      dashboard = {
        preset = {
          --          header = [[
          --███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
          --████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
          --██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
          --██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
          --██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
          --╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Plugins", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { pading = 1 },
          {
            section = "terminal",
            cmd = "cat ~/.config/profile_ascii_x3.txt ; sleep 0.05",
            --cmd = "paste -d '' ~/.config/margin.txt{,,,,} ~/.config/profile_ascii.txt{,,} ; sleep 0.1",
            --cmd = "paste -d '' ~/.config/profile_ascii.txt{,,,} ; sleep 0.1",
            --cmd = "chafa ~/.config/Profile2_Small.png --format symbols --symbols vhalf --size 15x15 --polite on",
            --cmd = "cat ~/.config/profile_ascii.txt",
            height = 8,
            padding = 1,
            indent = 7,
          },
          { pading = 1 },
          { section = "keys", gap = 1, padding = 1 },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            return {
              section = "terminal",
              enabled = in_git,
              icon = " ",
              title = "Git Status",
              cmd = "git status --short",
              height = 3,
              ttl = 5 * 60,
            }
          end,
          { section = "startup" },
          --{
          --  pane = 2,
          --  section = "terminal",
          --  cmd = "colorscript -e square",
          --  height = 5,
          --  padding = 1,
          --},
          --{
          --  pane = 2,
          --  icon = " ",
          --  desc = "Browse Repo",
          --  padding = 1,
          --  key = "b",
          --  action = function()
          --    Snacks.gitbrowse()
          --  end,
          --},
          --function()
          --  local in_git = Snacks.git.get_root() ~= nil
          --  local cmds = {
          --    {
          --      title = "Open Issues",
          --      cmd = "gh issue list -L 3",
          --      key = "i",
          --      action = function()
          --        vim.fn.jobstart("gh issue list --web", { detach = true })
          --      end,
          --      icon = " ",
          --      height = 7,
          --    },
          --    {
          --      icon = " ",
          --      title = "Open PRs",
          --      cmd = "gh pr list -L 3",
          --      key = "P",
          --      action = function()
          --        vim.fn.jobstart("gh pr list --web", { detach = true })
          --      end,
          --      height = 7,
          --    },
          --    {
          --      icon = " ",
          --      title = "Git Status",
          --      cmd = "git --no-pager diff --stat -B -M -C",
          --      height = 10,
          --    },
          --  }
          --  return vim.tbl_map(function(cmd)
          --    return vim.tbl_extend("force", {
          --      pane = 2,
          --      section = "terminal",
          --      enabled = in_git,
          --      padding = 1,
          --      ttl = 5 * 60,
          --      indent = 3,
          --    }, cmd)
          --  end, cmds)
          --end,
        },
        ----Startify style:
        --formats = {
        --  key = function(item)
        --    return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        --  end,
        --},
        --sections = {
        --  { section = "terminal", cmd = "fortune -s | cowsay", hl = "header", padding = 1, indent = 8 },
        --  { title = "MRU", padding = 1 },
        --  { section = "recent_files", limit = 8, padding = 1 },
        --  { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
        --  { section = "recent_files", cwd = true, limit = 8, padding = 1 },
        --  { title = "Sessions", padding = 1 },
        --  { section = "projects", padding = 1 },
        --  { title = "Bookmarks", padding = 1 },
        --  { section = "keys" },
        --},
      },
      -- Show hidden files by default in mini explorer
      picker = {
        sources = {
          explorer = { hidden = true },
        },
      },
    },
    keys = {
      { "<leader>ud", enabled = false },
      {
        "<leader>ud",
        function()
          Snacks.toggle.toggles["diags"]:toggle()
        end,
        silent = false,
        desc = "Toggle diagnostics globally",
      },
      { "<leader>uD", enabled = false },
      {
        "<leader>uD",
        function()
          Snacks.toggle.toggles["diags_buf"]:toggle()
        end,
        silent = false,
        desc = "Toggle diagnostics in current buffer",
      },
    },
    -- custom toggles
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- -- Find original dim one by <leader>uD and disable it
          -- print("Before removing dim toggle:")
          -- for i, toggle in ipairs(Snacks.toggle.toggles) do
          --   if toggle.opts.name == "Dimming" then
          --     table.remove(Snacks.toggle.toggles, i)
          --     break
          --   end
          -- end
          -- Mine
          Snacks.toggle
            .diagnostics({ id = "diags", name = " Diagnostics (Global)" })
            :map("<leader>ud")
            :_wk("<leader>ud", "n")
          Snacks.toggle
            .new({
              id = "diags_buf",
              name = " Diagnostics (Buffer)",
              set = function(state)
                vim.diagnostic.enable(state, { bufnr = 0 })
              end,
              get = function()
                return vim.diagnostic.is_enabled({ bufnr = 0 })
              end,
              which_key = true,
              -- wk_desc = "Toggle diagnostics in current buffer",
            })
            :map("<leader>uD")
            :_wk("<leader>uD", "n")
          Snacks.toggle
            .new({
              id = "diags_buf",
              name = " Diagnostics (Buffer)",
              set = function(state)
                vim.diagnostic.enable(state, { bufnr = 0 })
              end,
              get = function()
                return vim.diagnostic.is_enabled({ bufnr = 0 })
              end,
              which_key = true,
              -- wk_desc = "Toggle diagnostics in current buffer",
            })
            :map("<leader>uud")
          Snacks.toggle
            .new({
              id = "dim",
              name = "󰱊 Dimming",
              get = function()
                return Snacks.dim.enabled
              end,
              set = function(state)
                if state then
                  Snacks.dim.enable()
                else
                  Snacks.dim.disable()
                end
              end,
            })
            :map("<leader>uM")
          -- Remove original uD toggle mapping
          -- Snacks.toggle.dim():map("<leader>uD", { enabled = false })
          -- :map(
          --   "<leader>uD",
          --   { enabled = false }
          -- )
          -- require('which-key').add({
          --   ["<leader>ud"] = { name = " Diagnostics (Global)" },
          --   ["<leader>uD"] = { name = " Diagnostics (Buffer)" },
          -- })
          -- Reddit's
          Snacks.toggle.option("spell", { name = "󰓆 Spell Checking" }):map("<leader>uus")
          Snacks.toggle.option("wrap", { name = "󰖶 Wrap Long Lines" }):map("<leader>uuw")
          Snacks.toggle.option("list", { name = "󱁐 List (Visible Whitespace)" }):map("<leader>uul")
          -- Snacks.toggle.diagnostics({ name = " Diagnostics" }):map("<leader>uuD")
          Snacks.toggle.treesitter({ name = " Treesitter Highlighting" }):map("<leader>uut")

          Snacks.toggle
            .new({
              id = "diag_virtual_text",
              name = " Diagnostics Virtual Text",
              get = function()
                return vim.diagnostic.config().virtual_text ~= false
              end,
              set = function(state)
                require("tiny-inline-diagnostic").toggle()
                if state then
                  vim.diagnostic.config({ virtual_text = { prefix = "", spacing = 2 } })
                else
                  vim.diagnostic.config({ virtual_text = false })
                end
              end,
            })
            :map("<leader>uuv")

          Snacks.toggle
            .new({
              id = "git_blame",
              name = " Git Blame",
              get = function()
                return require("gitsigns.config").config.current_line_blame
              end,
              set = function(state)
                require("gitsigns").toggle_current_line_blame(state)
              end,
            })
            :map("<leader>uub")

          Snacks.toggle
            .new({
              id = "git_sign_column",
              name = " Git Sign Column",
              get = function()
                return require("gitsigns.config").config.signcolumn
              end,
              set = function(state)
                require("gitsigns").toggle_signs(state)
              end,
            })
            :map("<leader>uug")

          Snacks.toggle
            .new({
              id = "number",
              name = " Line Numbers",
              get = function()
                return vim.wo.number
              end,
              set = function(state)
                if state then
                  vim.wo.relativenumber = false
                end
                vim.wo.number = state
              end,
            })
            :map("<leader>uun")

          Snacks.toggle
            .new({
              id = "relativenumber",
              name = " Relative Line Numbers",
              get = function()
                return vim.wo.relativenumber
              end,
              set = function(state)
                if state then
                  vim.wo.number = false
                end
                vim.wo.relativenumber = state
              end,
            })
            :map("<leader>uuN")

          Snacks.toggle
            .new({
              id = "format_on_save",
              name = "󰊄 Format on Save (global)",
              get = function()
                return not vim.g.disable_autoformat
              end,
              set = function(state)
                vim.g.disable_autoformat = not state
              end,
            })
            :map("<leader>uuf")

          Snacks.toggle
            .new({
              id = "format_on_save_buffer",
              name = "󰊄 Format on Save (buffer)",
              get = function()
                return not vim.b.disable_autoformat
              end,
              set = function(state)
                vim.b.disable_autoformat = not state
              end,
            })
            :map("<leader>uuF")

          Snacks.toggle
            .new({
              id = "copilot",
              name = " Copilot",
              get = function()
                return require("copilot-status").is_enabled()
              end,
              set = function(state)
                if state then
                  vim.cmd("Copilot enable")
                else
                  vim.cmd("Copilot disable")
                end
              end,
            })
            :map("<leader>uuc")

          Snacks.toggle
            .new({
              id = "dim",
              name = "󰱊 Dimming",
              get = function()
                return Snacks.dim.enabled
              end,
              set = function(state)
                if state then
                  Snacks.dim.enable()
                else
                  Snacks.dim.disable()
                end
              end,
            })
            :map("<leader>uum")

          Snacks.toggle
            .new({
              id = "inline_hints",
              name = " LSP Inline Hints",
              get = vim.lsp.inlay_hint.is_enabled,
              set = function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end,
            })
            :map("<leader>uui")

          Snacks.toggle
            .new({
              id = "inline_hints_end",
              name = " LSP Inline Hints at Line End",
              get = function()
                return vim.g.snacks_toggle_lsp_hints_end
              end,
              set = function()
                require("lsp-endhints").toggle()
                vim.g.snacks_toggle_lsp_hints_end = not vim.g.snacks_toggle_lsp_hints_end
              end,
            })
            :map("<leader>uuI")
        end,
      })
    end,
  },
}
--  vim: set ts=8 sw=2 tw=80 et :
