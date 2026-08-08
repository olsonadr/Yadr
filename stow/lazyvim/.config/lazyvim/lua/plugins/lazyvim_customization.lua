-- For customization of plugins installed by lazyvim or lazyvim extras

-- Source - https://stackoverflow.com/a/4991602
local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Check if certain plugins should be disabled on this host
local enable_copilot = not file_exists(vim.fn.expand("$HOME/.no-copilot"))
local enable_cody = not file_exists(vim.fn.expand("$HOME/.no-cody"))

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
      inlay_hints = { enabled = true },
      servers = {
        racket_langserver = {},
        marksman = { mason = false },
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
    dependencies = { (enable_cody and "sourcegraph/sg.nvim" or nil) },
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
    -- enabled = false,
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
    enabled = enable_cody,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },
  -- Alternative Cody support
  {
    "guillemaru/codyassist",
    enabled = enable_cody,
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
  },
  -- TODO: customize vimtex
  {
    "lervag/vimtex",
    lazy = false, -- VimTeX must load on startup for proper callback/inverse search functionality
    opts = function()
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-shell-escape", -- Required for minted
        },
      }
    end,
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      oldfiles = {
        -- In Telescope, when I used <leader>fr, it would load old buffers.
        -- fzf lua does the same, but by default buffers visited in the current
        -- session are not included. I use <leader>fr all the time to switch
        -- back to buffers I was just in. If you missed this from Telescope,
        -- give it a try.
        include_current_session = true,
      },
      previewers = {
        builtin = {
          -- fzf-lua is very fast, but it really struggled to preview a couple files
          -- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
          -- It turns out it was Treesitter having trouble parsing the files.
          -- With this change, the previewer will not add syntax highlighting to files larger than 100KB
          -- (Yes, I know you shouldn't have 100KB minified files in source control.)
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      grep = {
        -- One thing I missed from Telescope was the ability to live_grep and the
        -- run a filter on the filenames.
        -- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
        -- With this change, I can sort of get the same behaviour in live_grep.
        -- ex: > enable --*/plugins/*
        -- I still find this a bit cumbersome. There's probably a better way of doing this.
        rg_glob = true, -- enable glob parsing
        glob_flag = "--iglob", -- case insensitive globs
        glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
      },
    },
  },
}

--  vim: set ts=8 sw=2 tw=80 et :
