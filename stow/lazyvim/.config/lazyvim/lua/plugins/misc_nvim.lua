-- For misc nvim plugins

return {
  -- hop: like easymotion but without the buffer modification issues
  {
    "smoka7/hop.nvim",
    -- version = "*",
    opts = {
      -- keys = "jk",
      keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      {
        "<leader>j",
        mode = { "n", "v" },
        function()
          require("hop").hint_lines({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })
        end,
        desc = "Hop to line below",
      },
      {
        "<leader>k",
        mode = { "n", "v" },
        function()
          require("hop").hint_lines({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
        end,
        desc = "Hop to line above",
      },
    },
  },
  -- nvim-scrollbar: extensible mini scrollbar
  {
    "petertriho/nvim-scrollbar",
    opts = {
      show_in_active_only = true,
      handlers = {
        cursor = true,
        diagnostic = true,
        search = false, -- Requires hlslens
        gitsigns = false, -- Requires gitsigns
        handle = true,
        viewport = true,
      },
    },
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
  -- nvim-treesitter: pin version to avoid regression
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    -- commit = "f7955203bb16eed15f9e0fbf7e39b86e0de96b47",
  },
  -- jupytext.nvim: converting to/from ipynb
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {},
  },
  -- colorful-winsep.nvim: colorful borders around active window
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
    opts = {
      animate = { enabled = false }
    }
  },
}
--  vim: set ts=8 sw=2 tw=80 et :
