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
      panel = { enabled = false },
    },
  },
  -- Disable inlay hints by default
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
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
  -- Make tab do snippet forward, ai_accept, *and* confirm, and remove <CR> for
  -- confirmation
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert({
        -- Override mappings
        ["<tab>"] = function(fallback)
          LazyVim.cmp.map({ "snippet_forward", "ai_accept", "confirm" }, fallback)()
        end,
        ["<CR>"] = cmp.config.disable,
        ["<C-Space>"] = cmp.mapping.complete(),
        -- Default mappings
        -- ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
        -- ["<tab>"] = function(fallback)
        --   return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
        -- end,
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
}

--  vim: set ts=8 sw=2 tw=80 et :
