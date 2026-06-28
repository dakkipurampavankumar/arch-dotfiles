return {
  'mrcjkb/rustaceanvim',
  version = '^5', -- Recommended
  lazy = false, -- This plugin is already lazy
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- Auto-format on save for Rust files
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            lru = {
              capacity = 128, -- Cap internal cache to save RAM
            },
            cargo = {
              allFeatures = true,
            },
            checkOnSave = true,
            check = {
              command = "clippy",
            },
          },
        },
      },
    }
  end,
}
