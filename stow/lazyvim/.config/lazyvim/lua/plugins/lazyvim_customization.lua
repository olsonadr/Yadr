-- For customization of plugins installed by lazyvim or lazyvim extras

-- Source - https://stackoverflow.com/a/4991602
local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- Check if certain plugins should be disabled on this host
local enable_copilot = file_exists("~/.no-copilot")

return {
  -- Configure LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  -- Enable completions
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = true },
      panel = { enabled = false },
    },
  },
  -- lspconfig settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
      },
      servers = {
        racket_langserver = {},
      },
    },
  },
  -- Conform respect modeline
  {
    "stevearc/conform.nvim",
    opts = {
      formattersprettier = {
        prepend_args = {
          "--print-width",
          "80",
          "--config-precedence",
          "prefer-file",
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "sourcegraph/sg.nvim" },
    opts = function(_, opts)
      -- Enable cody
      table.insert(opts.sources, 1, { name = "cody" })
      -- Default
      local cmp = require("cmp")
      local auto_select = false
      opts.completion = {
        completeopt = "menu,menuone,noselect",
      }
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
        ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
        ["<S-CR>"] = LazyVim.cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<tab>"] = function(fallback)
          return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
        end,
      })
    end,
  },
  -- Remove copilot status icon from lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      if opts.sections and opts.sections.lualine_x then
        opts.sections.lualine_x = vim.tbl_filter(function(item)
          return item ~= "copilot"
        end, opts.sections.lualine_x)
      end
    end,
  },
  -- Tmp disable copilot cmp
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
  },
  -- Include bufferline even when only one buffer
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  -- Add surround-style maps for mini.surround
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        -- add = "ys", -- Add surrounding in Normal and Visual modes
        -- delete = "ds", -- Delete surrounding
        -- replace = "cs", -- Replace surrounding
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        replace = "gsr", -- Replace surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        update_n_lines = "gsN", -- Update `n_lines`
      },
    },
  },
  -- conjure for repl support in racket
  {
    "Olical/conjure",
    ft = { "racket", "scheme" },
    lazy = true,
    init = function()
    end,
  },
  -- Disable copilot plugins if flagfile found in home dir
  {
    "zbirenbaum/copilot.lua",
    enabled = enable_copilot,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = enable_copilot,
  },
  -- Cody support
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },
  -- Alternative Cody support
  {
    "guillemaru/codyassist",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codyassist").setup()
      vim.keymap.set("v", "<leader>aq", function()
        local variable = {}
        variable.args = "Explain this code:"
        require("codyassist").QuestionWithSelection(variable)
      end, { noremap = true, silent = true, desc = "Ask Cody about selection" })
      vim.keymap.set("n", "<leader>ae", function()
        require("codyassist").EnableRepo()
      end, { noremap = true, silent = true, desc = "Enable using Cody context repo" })
      vim.keymap.set("n", "<leader>ad", function()
        require("codyassist").DisableRepo()
      end, { noremap = true, silent = true, desc = "Disable using Cody context repo" })
      vim.keymap.set("n", "<leader>at", function()
        require("codyassist").ToggleChatWindow()
      end, { noremap = true, silent = true, desc = "Toggle window with Cody's answer" })
    end,
  }
  -- TODO: Remove mini-snippets <c-cr> map
}

--  vim: set ts=8 sw=2 tw=80 et :
