return {
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    main = "nvim-silicon",
    opts = {
      disable_defaults = true,
    },
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>sc", ":Silicon<CR>", desc = "Snapshot Code", mode = "v" },
      })
    end,
    config = function()
      require("nvim-silicon").setup({
        background = "#eeeeee",
        theme = "Monokai Extended Light",
        font = "Hack Nerd Font Mono=20;Noto Color Emoji=20",
      })
    end,
  },
}
