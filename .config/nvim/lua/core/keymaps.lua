-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic navigation
map("n", "<leader>nh", ":nohl<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>x", ":x<CR>", opts)

-- Window management
map("n", "<leader>sv", "<C-w>v", opts) -- split vertically
map("n", "<leader>sh", "<C-w>s", opts) -- split horizontally
map("n", "<leader>se", "<C-w>=", opts) -- make splits equal size
map("n", "<leader>sx", ":close<CR>", opts) -- close current split

-- Tabs
map("n", "<leader>to", ":tabnew<CR>", opts)
map("n", "<leader>tx", ":tabclose<CR>", opts)
map("n", "<leader>tn", ":tabn<CR>", opts)
map("n", "<leader>tp", ":tabp<CR>", opts)

-- File explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- LSP
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "<leader>f", function()
  vim.lsp.buf.format { async = true }
end, opts)

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>ld", vim.diagnostic.open_float, opts)
map("n", "<leader>qf", vim.diagnostic.setloclist, opts)

