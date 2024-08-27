-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
  -- Install Lsp and formatters using Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    event = "BufReadPre", -- Lazy-load Mason
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local servers = { "cssls", "html", "jsonls", "tsserver" }
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common on_attach function for all servers
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        -- Add more mappings if needed
      end

      -- Iterate over servers to set them up
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- Special case for tsserver to disable formatting
      lspconfig.tsserver.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false -- Disable tsserver formatting
          on_attach(client, bufnr) -- Call common on_attach
        end,
        capabilities = capabilities,
      })
    end,
  },
}
