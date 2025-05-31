-- ~/.config/nvim/init.lua
-- Bootstrap lazy.nvim FIRST
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- Core config (non-plugin-dependent)
require("core.options")
require("core.keymaps")

-- Plugin setup
require("lazy").setup(require("core.plugins"))

-- Plugin-dependent config after lazy.nvim completes
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        require("core.theme") -- colorscheme, lualine
        require("core.lsp") -- mason, lspconfig, null-ls
        -- Add more if needed: dap, telescope, etc.
    end
})
