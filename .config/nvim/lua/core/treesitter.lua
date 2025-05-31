-- ~/.config/nvim/lua/core/treesitter.lua

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua",
    "typescript",
    "javascript",
    "json",
    "html",
    "css",
    "go",
    "python",
    "graphql",
    "astro",
    "tsx",
    "json"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  autotag = {
    enable = true,
  },
}

