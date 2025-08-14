-- For customization of plugins installed by lazyvim or lazyvim extras

return {
  -- Configure LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  --  {
  --    "folke/snacks.nvim",
  --    opts = {
  --      dashboard = {
  --        enabled = false,
  --        preset = { header = "wow" },
  --      },
  --    },
  --  },
}
--  -- Configure dashboard
--  {
--    "folke/snacks.nvim",
--    opts = {
--      dashboard = {
--        preset = {
--          pick = function(cmd, opts)
--            return LazyVim.pick(cmd, opts)()
--          end,
--          --          header = [[
--          --███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
--          --████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
--          --██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
--          --██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
--          --██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
--          --╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
--          header = [[
--      ▄▄▄
--    ▄▄▄▄▄▄▄
--  ▄▄▄▄▄▄▄▄▄▄▄
--▄▄▄▄  ▄▄▄  ▄▄▄▄
--▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
--  ▄▄  ▄▄▄  ▄▄
--▄▄           ▄▄
--  ▄▄       ▄▄
--            ]],
--          -- stylua: ignore
--          ---@type snacks.dashboard.Item[]
--          keys = {
--            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
--            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
--            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
--            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
--            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
--            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
--            { icon = " ", key = "x", desc = "Extras", action = ":LazyExtras" },
--            { icon = "󰒲 ", key = "l", desc = "Plugins", action = ":Lazy" },
--            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
--          }, -- Optionally, use startify style:
--          formats = {
--            key = function(item)
--              return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
--            end,
--          },
--          sections = {
--            { section = "terminal", cmd = "fortune -s | cowsay", hl = "header", padding = 1, indent = 8 },
--            { title = "MRU", padding = 1 },
--            { section = "recent_files", limit = 8, padding = 1 },
--            { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
--            { section = "recent_files", cwd = true, limit = 8, padding = 1 },
--            { title = "Sessions", padding = 1 },
--            { section = "projects", padding = 1 },
--            { title = "Bookmarks", padding = 1 },
--            { section = "keys" },
--          },
--        },
--      },
--    },
--  },
