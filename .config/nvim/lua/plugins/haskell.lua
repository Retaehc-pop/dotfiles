return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "haskell" } },
  },
  --{
  --  "mrcjkb/haskell-tools.nvim",
  --  version = "^3",
  --  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  --  dependencies = {
  --    { "nvim-telescope/telescope.nvim", optional = true },
  --  },
  --  config = function()
  --    local ok, telescope = pcall(require, "telescope")
  --    if ok then
  --      telescope.load_extension("ht")
  --    end
  --  end,
  --},
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "haskell-language-server" } },
  },
  {
    "neovim/nvim-lspconfig",
    enable = false,
    opts = {
      setup = {
        hls = function()
          return true
        end,
      },
    },
  },
}
