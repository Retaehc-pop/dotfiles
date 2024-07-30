-- n, v, i, t = mode names

local M = {}

M.general = {
  i = {
    ["<C-d>"] = { "<ESC>:copy .<CR> a", "duplicate line" },
    ["<C-s>"] = { "<ESC>:w<CR>", "Save file" },
    ["<C-x>"] = { "<ESC> dd a", "Cut line" },
    ["<C-z>"] = { "<ESC>:undo <CR> a", "Undo" },
    ["<C-Up>"] = { "<ESC>:m -2<CR> a", "Move line down" },
    ["<C-Down>"] = { "<ESC>:m +1<CR> a", "Move line up" },
  },
  n = {
    ["<C-Down>"] = { ":m +1<CR>", "Move line up" },
    ["<C-Up>"] = { ":m -2<CR>", "Move line down" },
    ["<S-Up>"] = { "v gk", "Move up" },
    ["<S-Down>"] = { "v gj", "Move down" },
  },
  v = {
    ["<tab>"] = { ">gv", "Indent line" },
    ["<S-tab>"] = { "<gv", "Indent line" },
    ["<S-Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gk"', "Move down", opts = { expr = true } },
    ["<S-Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
  }
}

M.comment = {
  plugin = true,
  n = {
    ["<C-/>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    }
  },
  v = {
    ["<C-/>"] = {
      "<ESC><cmd> lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Add breakpoint at line" },
    ["<leader>dr"] = { "<cmd> DapContinue <CR>", "Start or Continue the debugger"},
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').text_method()
      end
    }
  }
}

M.nvimtree = {
  plugin = true,
  n = {
    ["C-b"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  }
}

M.nvim_silicon = {
  plugin = true,
  v = {
    ["<leader>sc"] = {":Silicon<CR>","Snapshot Code"}
  }
}
return M
