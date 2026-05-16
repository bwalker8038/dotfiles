return { -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        terminal_colors = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent"
        },
        on_highlights = function(hl, c)
          hl.CursorLineNr.fg = c.blue
          hl.LineNr.fg = c.fg_gutter
          hl.CursorLine.bg = c.bg_highlight
        end
      })
      vim.cmd("colorscheme tokyonight")
    end
  }, -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight"
        }
      })
    end
  },
  "tpope/vim-fugitive", { "lewis6991/gitsigns.nvim" }, -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" }
  }, -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  }, -- LSP and tools
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 1. Initialize Mason
      require("mason").setup()

      -- 2. Setup Mason-LSPConfig with Handlers
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "gopls", "lua_ls", "jsonls", "html", "cssls", "pyright" },
        handlers = {
          -- The first entry (without a key) is the default setup for ALL servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Target denols specifically
          ["denols"] = function()
            lspconfig.denols.setup({
              capabilities = capabilities,
              root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
              single_file_support = false, -- Don't start without a deno.json
            })
          end,

          -- Target ts_ls specifically
          ["ts_ls"] = function()
            lspconfig.ts_ls.setup({
              capabilities = capabilities,
              -- ONLY start if package.json exists AND deno.json does NOT
              root_dir = function(fname)
                local deno_root = lspconfig.util.root_pattern("deno.json", "deno.jsonc")(fname)
                if deno_root then return nil end
                return lspconfig.util.root_pattern("package.json", "bun.lockb")(fname)
              end,
              single_file_support = false,
            })
          end,
        },
      })
    end,
  },
  --{ "neovim/nvim-lspconfig" },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local sources = { null_ls.builtins.formatting.gofmt }

      null_ls.setup({
        sources = sources
      })
    end
  }, {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }
}, -- Autocompletion & snippets
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip", "zbirenbaum/copilot-cmp" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("copilot_cmp").setup()
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true
          })
        }),
        sources = cmp.config.sources({ {
          name = "copilot",
          group_index = 2
        }, {
          name = "nvim_lsp"
        }, {
          name = "luasnip"
        }, {
          name = "buffer"
        }, {
          name = "path"
        } }),
        sorting = {
          priority_weight = 2,
          comparators = { require("copilot_cmp.comparators").prioritize, cmp.config.compare.offset,
            cmp.config.compare.exact, cmp.config.compare.score, cmp.config.compare.kind,
            cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order }
        }
      })
    end
  }, -- prettier, formatters
  {
    "sbdchd/neoformat",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.scss", "*.html", "*.json", "*.md", "*.go", "*.py" },
        callback = function()
          vim.cmd("Neoformat")
        end
      })
    end
  }, -- sidekick for AI tools integration
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          --backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  }, -- snacks for various UI improvements and AI tool integrations
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
        tree = true,
        support_live = true,
        keys = {
          ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", "Toggle File Explorer" },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
      toggle = { enabled = true },
    },
  }, -- todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  }, -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false
        },
        panel = {
          enabled = false
        }
      })
    end
  }, -- minimap
  {
    "Isrothy/neominimap.nvim",
    lazy = false,
    keys = {
      -- Global Minimap Controls
      { "<leader>nm",  "<cmd>Neominimap Toggle<cr>",      desc = "Toggle global minimap" },
      { "<leader>no",  "<cmd>Neominimap Enable<cr>",      desc = "Enable global minimap" },
      { "<leader>nc",  "<cmd>Neominimap Disable<cr>",     desc = "Disable global minimap" },
      { "<leader>nr",  "<cmd>Neominimap Refresh<cr>",     desc = "Refresh global minimap" },

      -- Window-Specific Minimap Controls
      { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>",   desc = "Toggle minimap for current window" },
      { "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>",  desc = "Refresh minimap for current window" },
      { "<leader>nwo", "<cmd>Neominimap WinEnable<cr>",   desc = "Enable minimap for current window" },
      { "<leader>nwc", "<cmd>Neominimap WinDisable<cr>",  desc = "Disable minimap for current window" },

      -- Tab-Specific Minimap Controls
      { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>",   desc = "Toggle minimap for current tab" },
      { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>",  desc = "Refresh minimap for current tab" },
      { "<leader>nto", "<cmd>Neominimap TabEnable<cr>",   desc = "Enable minimap for current tab" },
      { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>",  desc = "Disable minimap for current tab" },

      -- Buffer-Specific Minimap Controls
      { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>",   desc = "Toggle minimap for current buffer" },
      { "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>",  desc = "Refresh minimap for current buffer" },
      { "<leader>nbo", "<cmd>Neominimap BufEnable<cr>",   desc = "Enable minimap for current buffer" },
      { "<leader>nbc", "<cmd>Neominimap BufDisable<cr>",  desc = "Disable minimap for current buffer" },

      ---Focus Controls
      { "<leader>nf",  "<cmd>Neominimap Focus<cr>",       desc = "Focus on minimap" },
      { "<leader>nu",  "<cmd>Neominimap Unfocus<cr>",     desc = "Unfocus minimap" },
      { "<leader>ns",  "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
    },
    init = function()
      -- Global Neovim options
      vim.opt.wrap = true
      vim.opt.sidescrolloff = 999

      vim.g.neominimap = {
        auto_enable = false,
        -- Change layout from 'float' to 'split'
        layout = "float",
        -- Ensure the minimap handles wrapped lines
        sync_cursor = true,
        -- Optional: adjust the width of the split
        width = 20,
        -- Place it on the right side
        split_direction = "rightbelow",
      }
    end,
  }, -- markdown, mermaid
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        -- all optional; sane defaults shown
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0,                   -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        debounce_ms = 300,
      })
    end,
  },                                                                          -- Surround, comments, autopairs
  "kylechui/nvim-surround", "numToStr/Comment.nvim", "windwp/nvim-autopairs", -- Multi-cursor
  "mg979/vim-visual-multi",                                                   -- Emmet
  "mattn/emmet-vim",                                                          -- Autotag for JSX, HTML, etc.
  "windwp/nvim-ts-autotag",                                                   -- Astro / Handlebars
  "wuelnerdotexe/vim-astro", "joukevandermaas/vim-ember-hbs" }
