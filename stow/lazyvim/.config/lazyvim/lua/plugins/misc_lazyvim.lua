-- For new plugins to be loaded for lazyvim but not nvim

return {
  -- conjure for repl support in racket
  {
    "Olical/conjure",
    enable = false,
    ft = { "racket", "scheme" },
    lazy = true,
    init = function() end,
  },
  -- molten: jupyter support
  {
    "benlubas/molten-nvim",
    enable = false,
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_output_win_max_height = 12
    end,
  },
  -- quarto-nvim: jupyter lsp
  {
    "quarto-dev/quarto-nvim",
    enable = false,
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "ariedov/android-nvim",
    enable = false,
    config = function()
      -- vim.g.android_sdk = "~/Library/Android/sdk"
      require("android-nvim").setup()
    end,
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    enable = false,
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = true,
  },
  -- RiscV
  {
    "henry-hsieh/riscv-asm-vim",
    enable = false,
    ft = { "riscv_asm" },
  },
  -- Open files from terminal
  {
    "willothy/flatten.nvim",
    config = true,
    -- opts = {  }
    lazy = false,
    priority = 1001,
  },
  -- Alt copilot
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    version = "^19.0.0",
    opts = {
      interactions = {
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-4.1",
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- -- focus.nvim: focus on current window
  -- {
  --   "nvim-focus/focus.nvim",
  --   version = "*",
  --   config = function()
  --     require("focus").setup({
  --       -- enable = true, -- Enable module
  --       enable = true, -- Enable module
  --       commands = true, -- Create Focus commands
  --       autoresize = {
  --         enable = true, -- Enable or disable auto-resizing of splits
  --         width = 0, -- Force width for the focused window
  --         height = 0, -- Force height for the focused window
  --         minwidth = 0, -- Force minimum width for the unfocused window
  --         minheight = 0, -- Force minimum height for the unfocused window
  --         focusedwindow_minwidth = 90, --Force minimum width for the focused window
  --         focusedwindow_minheight = 0, --Force minimum height for the focused window
  --         height_quickfix = 10, -- Set the height of quickfix panel
  --         equalise_min_cols = 0, -- Use equal splits when columns >= this value (0 = ignore)
  --         equalise_min_rows = 0, -- Use equal splits when rows >= this value (0 = ignore)
  --       },
  --       ui = {
  --         winhighlight = true, -- Auto highlighting for focussed/unfocussed windows
  --         number = false, -- Display line numbers in the focussed window only
  --         relativenumber = false, -- Display relative line numbers in the focussed window only
  --         hybridnumber = false, -- Display hybrid line numbers in the focussed window only
  --         absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows
  --
  --         cursorline = false, -- Display a cursorline in the focussed window only
  --         cursorcolumn = false, -- Display cursorcolumn in the focussed window only
  --         colorcolumn = {
  --           enable = false, -- Display colorcolumn in the foccused window only
  --           list = "+1", -- Set the comma-saperated list for the colorcolumn
  --         },
  --         signcolumn = false, -- Display signcolumn in the focussed window only
  --       },
  --       -- split = {
  --       --   bufnew = false, -- Create blank buffer for new split windows
  --       --   tmux = false, -- Create tmux splits instead of neovim splits
  --       -- },
  --     })
  --   end,
  -- },
}

--  vim: set ts=8 sw=2 tw=80 et :
