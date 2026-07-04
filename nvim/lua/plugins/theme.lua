return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000, -- Keep this high so colors load before the UI draws
  opts = {
    flavour = "mocha", -- "latte", "frappe", "macchiato", or "mocha"
    compile = true, -- Pre-compile theme to ~/.cache/nvim/catppuccin for faster startup
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
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        NormalNC = { bg = "none" },
        VertSplit = { bg = "none" },
        WinSeparator = { bg = "none" },
        Folded = { bg = "none" },
        NonText = { bg = "none" },
        SignColumn = { bg = "none" },
        EndOfBuffer = { bg = "none" },
        
        -- Fix for mini.files: give it a solid background so text doesn't overlap
        MiniFilesNormal = { bg = colors.mantle },
        MiniFilesBorder = { bg = colors.mantle, fg = colors.surface2 },
        MiniFilesTitle = { bg = colors.mantle, fg = colors.lavender, bold = true },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
