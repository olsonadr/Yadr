-- For customization of snacks plugin

return {
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
    },
  },
}
