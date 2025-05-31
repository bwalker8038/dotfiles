-- -- ~/.config/nvim/lua/core/lsp.lua
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()

mason_lspconfig.setup({
    ensure_installed = {"html", "cssls", "jsonls", "gopls", "pyright", "lua_ls"}
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup all LSP servers except TypeScript (handled by typescript-tools)
local servers = {"html", "cssls", "jsonls", "gopls", "pyright", "lua_ls"}

for _, server in ipairs(servers) do
    local ok, server_config = pcall(function()
        return lspconfig[server]
    end)

    if ok and server_config then
        server_config.setup({
            capabilities = capabilities
        })
    else
        vim.notify("LSP server not found or misconfigured: " .. server, vim.log.levels.WARN)
    end
end

-- Setup typescript-tools
local ts_ok, ts_tools = pcall(require, "typescript-tools")
if ts_ok then
    ts_tools.setup({
        capabilities = capabilities,
        settings = {
            separate_diagnostic_server = true,
            expose_as_code_action = "all",
            publish_diagnostic_on = "insert_leave"
        }
    })
else
    vim.notify("typescript-tools.nvim not installed", vim.log.levels.WARN)
end

-- null-ls setup
local null_ok, null_ls = pcall(require, "null-ls")
if null_ok then
    local sources = {null_ls.builtins.formatting.prettier}

    local has_config_file = function(utils)
        return utils.root_has_file({"eslint.config.js", "eslint.config.mjs", ".eslintrc.js", ".eslintrc.json",
                                    ".eslintrc.yaml", ".eslintrc.yml"})
    end

    local file_exists = function()
        return vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1
    end

    -- Primary: eslint_d (only if config exists and file is real)
    local eslint_d_ok, eslint_d = pcall(require, "none-ls.diagnostics.eslint_d")
    if eslint_d_ok then
        eslint_d.condition = function(utils)
            return has_config_file(utils) and file_exists()
        end
        table.insert(sources, eslint_d)
    else
        vim.notify("[none-ls-extras] eslint_d not available", vim.log.levels.WARN)
    end

    -- Fallback: global eslint with ~/.config/eslint/eslint.config.mjs
    local fallback_eslint = null_ls.builtins.diagnostics.eslint.with({
        command = "eslint",
        args = {"--config", os.getenv("HOME") .. "/.config/eslint/eslint.config.mjs", "--stdin", "--stdin-filename",
                "$FILENAME", "--format", "json"},
        condition = function(utils)
            return not has_config_file(utils) and file_exists()
        end
    })
    table.insert(sources, fallback_eslint)

    null_ls.setup({
        sources = sources
    })
end
