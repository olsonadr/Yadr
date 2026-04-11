-- For misc nvim plugins (nvim/lvim)

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
  -- -- Indentation Highlighting
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   ---@module "ibl"
  --   ---@type ibl.config
  --   opts = {},
  -- },
  -- Rainbow Highlighting
  {
    "HiPhish/rainbow-delimiters.nvim",
    keys = {
      {
        "<leader>uW",
        function()
          require("rainbow-delimiters").toggle(0)
        end,
        desc = "Toggle Rainbow Delimiters",
      },
    },
  },
  {
    "pappasam/vim-keywordprg-commands",
    init = function()
      vim.g.vim_keywordprg_commands = {
        DefEng = "dict -d wn %s",
        Pydoc = { "python3 -m pydoc %s", "rst" },
        SynEng = "dict -d moby-thesaurus %s",
      }
    end,
  },
}
--  vim: set ts=8 sw=2 tw=80 et :
