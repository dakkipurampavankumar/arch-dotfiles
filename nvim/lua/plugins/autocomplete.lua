return {
  -- 1. Memory Optimization for Lua/Neovim API
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- 2. Autocompletion Engine & Snippets
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          -- This is the giant library of snippets for C, Python, etc.
          'rafamadriz/friendly-snippets', 
        },
        build = (function()
          if vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      
      -- We must explicitly tell LuaSnip to load the friendly-snippets we just installed
      require("luasnip.loaders.from_vscode").lazy_load()
      
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        
        -- The solution to your alignment and rendering issue:
        formatting = {
          -- Sets the exact order of the columns
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind_icons = {
              Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
              Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
              Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
              Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
              File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
              Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
              TypeParameter = "󰊄",
            }
            
            -- 1. Put an icon next to the kind (e.g., "󰊕 Function")
            local icon = kind_icons[vim_item.kind] or ""
            vim_item.kind = string.format("%s %s", icon, vim_item.kind)

            -- 2. Prevent extremely long words from breaking the column width
            local MAX_ABBR = 30
            if string.len(vim_item.abbr) > MAX_ABBR then
              vim_item.abbr = string.sub(vim_item.abbr, 1, MAX_ABBR) .. "…"
            end

            -- 3. Prevent C/C++ function signatures from destroying the layout
            local MAX_MENU = 40
            if vim_item.menu ~= nil then
              if string.len(vim_item.menu) > MAX_MENU then
                vim_item.menu = string.sub(vim_item.menu, 1, MAX_MENU) .. "…"
              end
            end

            return vim_item
          end,
        },
        
        completion = { completeopt = 'menu,menuone,noinsert' },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
            -- Fix scrollbar visual bugs
            scrollbar = false, 
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:CmpDocBorder,CursorLine:PmenuSel,Search:None",
          }),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-e>'] = cmp.mapping.abort(),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer', keyword_length = 3 },
        },
        experimental = {
          ghost_text = true,
        },
      }

      -- Wire autopairs into cmp: auto-insert () after selecting a function
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
