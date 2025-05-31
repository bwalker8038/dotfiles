return { -- Theme
{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000
}, -- Statusline
{
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("lualine").setup({
            options = {
                theme = "tokyonight"
            }
        })
    end
}, -- File explorer
{
    "nvim-tree/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"}
}, -- Git
"tpope/vim-fugitive", {"lewis6991/gitsigns.nvim"}, -- Fuzzy finder
{
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {"nvim-lua/plenary.nvim"}
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
}, {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {"williamboman/mason.nvim"},
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {"ts_ls", "gopls", "lua_ls", "jsonls", "html", "cssls", "pyright"}
        })

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local servers = {"ts_ls", "gopls", "lua_ls", "jsonls", "html", "cssls", "pyright"}
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities
            })
        end
    end
}, {"neovim/nvim-lspconfig"}, {
    "nvimtools/none-ls.nvim",
    dependencies = {"nvimtools/none-ls-extras.nvim"},
    config = function()
        local null_ls = require("null-ls")
        local sources = {null_ls.builtins.formatting.prettier}

        local has_eslint_d = vim.fn.executable("eslint_d") == 1
        if has_eslint_d then
            table.insert(sources, require("none-ls.diagnostics.eslint_d"))
        end

        null_ls.setup({
            sources = sources
        })
    end
}, {
    "pmizio/typescript-tools.nvim",
    dependencies = {"nvim-lua/plenary.nvim"}
}, -- Autocompletion & snippets
{
    "hrsh7th/nvim-cmp",
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "saadparwaiz1/cmp_luasnip",
                    "L3MON4D3/LuaSnip", "zbirenbaum/copilot-cmp"},
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
            sources = cmp.config.sources({{
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
            }}),
            sorting = {
                priority_weight = 2,
                comparators = {require("copilot_cmp.comparators").prioritize, cmp.config.compare.offset,
                               cmp.config.compare.exact, cmp.config.compare.score, cmp.config.compare.kind,
                               cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order}
            }
        })
    end
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
}, -- Surround, comments, autopairs
"kylechui/nvim-surround", "numToStr/Comment.nvim", "windwp/nvim-autopairs", -- Multi-cursor
"mg979/vim-visual-multi", -- Emmet
"mattn/emmet-vim", -- Autotag for JSX, HTML, etc.
"windwp/nvim-ts-autotag", -- Astro / Handlebars
"wuelnerdotexe/vim-astro", "joukevandermaas/vim-ember-hbs"}
