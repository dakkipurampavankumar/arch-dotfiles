return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = 130,   -- width of the centered text block
      }
    },

  vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', {desc = "ZenMode"})
}
