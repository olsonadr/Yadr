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
  }
}

--  vim: set ts=8 sw=2 tw=80 et :
