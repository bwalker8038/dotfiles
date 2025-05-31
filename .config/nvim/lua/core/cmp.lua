-- ~/.config/nvim/lua/core/cmp.lua
-- Deprecated module, setup is done in plugins.lua
local cmp = require("cmp")
local luasnip = require("luasnip")
-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()
-- Initialize copilot-cmp now that plugins have loaded
require("copilot_cmp").setup()
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
