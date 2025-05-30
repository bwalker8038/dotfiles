-- ~/.config/nvim/lua/core/theme.lua

vim.cmd("colorscheme tokyonight")

-- Optional lualine setup
require("lualine").setup {
  options = {
    theme = "tokyonight",
    section_separators = "",
    component_separators = "|",
  },
}

