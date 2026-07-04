return {
  "echasnovski/mini.nvim",
  version = false,
  keys = {
    {
      "<leader>e",
      function()
        if not require("mini.files").close() then
          -- Open mini.files to the directory of the current file
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end
      end,
      desc = "Open File Explorer (mini.files)",
    },
  },
  config = function()
    require("mini.files").setup({
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = '<CR>',
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '<C-s>', -- mapped to save changes, matches your save bind
        trim_left   = '<',
        trim_right  = '>',
      },
      windows = {
        -- Enable the preview pane by default to get the 3-pane view
        preview = true,
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 40,
      },
      options = {
        -- Use the active window when opening a file, rather than a split
        use_as_default_explorer = true,
      },
    })
  end,
}
