return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cuda",
        "cmake",
        "lua",
        "json",
        "markdown",
        "python",
        "typescript",
        "tsx",
        "vim",
        "yaml",
        "html",
        "javascript",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_by_pattern = {
            "*.o", -- hide object files
          },
        },
      },
    },
  },
}
