-- For customization of plugins installed by lazyvim or lazyvim extras

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
      panel = { enabled = true },
    },
    keys = {
      { "<leader>at", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
    },
  },
  -- TODO: remove C-L mapping from CopilotChat which clears the chat window
  -- Plugin:
  -- ● CopilotChat.nvim 15.9ms  <leader>aa
  --     url    https://github.com/CopilotC-Nvim/CopilotChat.nvim
  { "CopilotC-Nvim/CopilotChat.nvim", opts = {} },
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
    opts = function(_, opts)
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
          return LazyVim.cmp.map({ "ai_accept", "snippet_forward" }, fallback)()
          -- return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
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
  -- Disable copilot-chat auto insert mode
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      auto_insert_mode = false,
    },
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
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main",
    opts = {},
  },
}

--  vim: set ts=8 sw=2 tw=80 et :
