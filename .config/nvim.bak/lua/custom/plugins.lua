local cmp = require "cmp"

local plugins = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require("custom.configs.null-ls")
    end,
  },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
      disable_defaults = true
    },
    init = function()
       require("core.utils").load_mappings("nvim_silicon")
    end,
    config = function()
      require("nvim-silicon").setup({

      })
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    dependencies = {
      'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim'
    },
    config = function()
      require('render-markdown').setup({})
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "lervag/vimtex",
    lazy=false,
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_syntax_enable = 0
    end
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_,_)
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_,_)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "nvim-neotest/nvim-nio",
    event = "VeryLazy",
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
      ensure_installed = {
        "codelldb",
      }
    }
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   lazy = false,
  --   opts = function ()
  --    return require "custom.configs.copilot"
  --   end,
  --   config = function(_, opts)
  --   require("copilot").setup(opts)
  --   end
  -- },
  -- {
  --  'xuhdev/vim-latex-live-preview'
  -- },
  {
    "anuvyklack/pretty-fold.nvim",
    lazy = false,
    config = function()
      require("pretty-fold").setup()
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        --cpp
        "clangd",
        "clang-format",
        "codelldb",
        -- python
        "pyright",
        "ruff-lsp",
        "debugpy",
        "mypy",
        "black",
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "numToStr/Comment.nvim",
    lazy = false
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
     M.completion.completeopt = "menu,menuone,noselect"
     M.mapping["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      M.mapping["<C-j>"] = cmp.mapping(function(_fallback)
        cmp.mapping.abort()
        require("copilot.suggestion").accept_line()
      end, {
          "i",
         "s",
       })

      table.insert(M.sources, {name = "crates"})
      return M
    end,
  },
}
return plugins
