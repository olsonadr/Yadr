-- For new plugins to be loaded for lazyvim but not nvim

return {
  -- conjure for repl support in racket
  {
    "Olical/conjure",
    ft = { "racket", "scheme" },
    lazy = true,
    init = function() end,
  },
  -- molten: jupyter support
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_output_win_max_height = 12
    end,
  },
  -- quarto-nvim: jupyter lsp
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- jupytext.nvim: converting to/from ipynb
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {}, -- see Options
  },
  {
    "ariedov/android-nvim",
    config = function()
      -- vim.g.android_sdk = "~/Library/Android/sdk"
      require("android-nvim").setup()
    end,
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = true,
  },
  -- Devcontainer support
  {
    "https://codeberg.org/esensar/nvim-dev-container",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  -- RiscV
  {
    "henry-hsieh/riscv-asm-vim",
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
}

--  vim: set ts=8 sw=2 tw=80 et :
