-- ~/.config/nvim/lua/core/lsp.lua

local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup {
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "jsonls",
    "gopls",
    "pyright",
    "lua_ls",
  },
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  "tsserver",
  "html",
  "cssls",
  "jsonls",
  "gopls",
  "pyright",
  "lua_ls",
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
  }
end

-- Formatting and linting with none-ls (formerly null-ls)
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint,
  },
})

