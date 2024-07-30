local base = require("plugins.configs.lspconfig")
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig" 
local util = require "lspconfig/util"

lspconfig.pylsp.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 100,
          indentSize = 4,
          ignore = "E501",
        }
      }
    }
  }
}

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"rust"},
  root_dir = lspconfig.util.root_pattern("Cargo.toml"),
})

lspconfig.clangd.setup {
  on_attach = function(client,bufnr)
    client.server_capabilities.signatureHelpProvide = false
    on_attach(client,bufnr)
  end,
  capabilities = capabilities,
}
