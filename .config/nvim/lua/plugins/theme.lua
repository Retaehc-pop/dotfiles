return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  -- add nordic
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load()
    end,
  },

  { "shaunsingh/nord.nvim" },
  -- Configure LazyVim to load theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}
