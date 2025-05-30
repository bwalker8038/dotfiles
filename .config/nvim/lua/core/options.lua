-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 300
opt.timeoutlen = 500
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
opt.list = true
opt.listchars = { tab = "▸ ", trail = "▫" }
opt.wildmode = { "longest", "list", "full" }
opt.wildignore:append({ "log/**", "node_modules/**", "target/**", "tmp/**", "*.rbc" })


