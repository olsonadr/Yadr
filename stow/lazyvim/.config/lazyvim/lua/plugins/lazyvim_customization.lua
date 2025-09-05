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
        enabled = true,
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
        -- Override mappings
        --       ["<tab>"] = function(fallback)
        --         -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
        --         if cmp.visible() then
        --           local entry = cmp.get_selected_entry()
        --           if not entry then
        --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        --           end
        --           cmp.confirm()
        --         else
        --           fallback()
        --         end
        --       end,
        --       -- ["<tab>"] = function(fallback)
        --       --   LazyVim.cmp.map({ "confirm", "snippet_forward", "ai_accept" }, fallback)()
        --       -- end,
        -- ["<CR>"] = cmp.config.disable,
        -- Default mappings
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
  -- Remove mini-snippets <c-cr> map
}

--  vim: set ts=8 sw=2 tw=80 et :
