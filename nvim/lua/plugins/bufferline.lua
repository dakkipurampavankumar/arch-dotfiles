return {
  'akinsho/bufferline.nvim',
  event = "VeryLazy",
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
    'catppuccin', 
  },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'Bdelete! %d',
        buffer_close_icon = '✗',
        close_icon = '✗',
        path_components = 1,
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = false,
        diagnostics_update_in_insert = false,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,
        separator_style = { '│', '│' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,
        indicator = {
          style = 'none',
        },
        icon_pinned = '󰐃',
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = 'insert_at_end',
      },
      highlights = {
        fill = {
          bg = '#24273a', -- Blends the empty space perfectly
        },
        background = {
          fg = '#6e738d', -- Macchiato Overlay0 (Inactive text)
          bg = '#24273a',
        },
        buffer_selected = {
          fg = '#cad3f5', -- Macchiato Text (Active text)
          bg = '#24273a',
          bold = true,
          italic = false,
        },
        separator = {
          fg = '#363a4f', -- Soft separator color to match borders
          bg = '#24273a',
        },
        separator_selected = {
          fg = '#363a4f',
          bg = '#24273a',
        },
        indicator_selected = {
          fg = '#b7bdf8', -- Macchiato Lavender
          bg = '#24273a',
        },
        modified = {
          fg = '#ed8796', -- Macchiato Red
          bg = '#24273a',
        },
        modified_selected = {
          fg = '#ed8796',
          bg = '#24273a',
        },
      },
    }
  end,
}
