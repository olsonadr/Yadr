-- For misc nvim plugins

return {
  -- like easymotion but without the buffer modification issues
  {
    "smoka7/hop.nvim",
    -- version = "*",
    opts = {
      -- keys = "jk",
      keys = 'etovxqpdygfblzhckisuran'
    },
    keys = {
      { "<leader>j", function() require("hop").hint_lines({ direction = require("hop.hint").HintDirection.AFTER_CURSOR }) end, desc = "Hop to line below" },
      { "<leader>k", function() require("hop").hint_lines({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR }) end, desc = "Hop to line above" },
    },
  },
}
