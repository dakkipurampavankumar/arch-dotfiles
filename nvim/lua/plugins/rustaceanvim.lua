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
      dap = {
        adapter = function()
          local mason_registry = require('mason-registry')
          local codelldb = mason_registry.get_package('codelldb')
          local codelldb_path = codelldb:get_install_path() .. '/extension/adapter/codelldb'
          return {
            type = 'server',
            port = '${port}',
            executable = {
              command = codelldb_path,
              args = { '--port', '${port}' },
            },
          }
        end,
      },
    }

    -- Rust-specific debug keymap (uses cargo to find the right target)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'rust',
      callback = function()
        vim.keymap.set('n', '<leader>dd', function() vim.cmd.RustLsp('debuggables') end,
          { buffer = true, desc = 'Debug: Rust Debuggables' })
      end,
    })
  end,
}
