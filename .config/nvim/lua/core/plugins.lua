-- ~/.config/nvim/lua/core/plugins.lua

-- Bootstrap lazy.nvim handled in init.lua
-- This file only returns the plugin list

return {
  -- Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

  -- Statusline
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- File explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Git
  "tpope/vim-fugitive",
  { "lewis6991/gitsigns.nvim" },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP and tools
  "neovim/nvim-lspconfig",
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  "williamboman/mason-lspconfig.nvim",
  { "nvimtools/none-ls.nvim" },

  -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Surround, comments, autopairs
  "kylechui/nvim-surround",
  "numToStr/Comment.nvim",
  "windwp/nvim-autopairs",

  -- Multi-cursor
  "mg979/vim-visual-multi",

  -- Emmet
  "mattn/emmet-vim",

  -- Tag closing
  "windwp/nvim-ts-autotag",

  -- Copilot
  "github/copilot.vim",

  -- Astro
  "wuelnerdotexe/vim-astro",

  -- Ember Handlebars
  "joukevandermaas/vim-ember-hbs",

  -- Debugging
  "mfussenegger/nvim-dap",

  -- Copilot integration
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

}
