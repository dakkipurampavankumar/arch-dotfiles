return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000, -- Keep this high so colors load before the UI draws
  opts = {
    flavour = "mocha", -- "latte", "frappe", "macchiato", or "mocha"
    transparent_background = true,
    term_colors = true,
    integrations = {
      cmp = true,
      fidget = true,
      mason = true,
      telescope = true,
      treesitter = true,
      -- These integrations ensure your LSP menus and Treesitter tags match perfectly
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
