return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { 
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons" -- Optional, but highly recommended for icons
  },
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    -- The plugin works great out of the box, but you can customize icons and rendering here
    heading = {
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      sign = true,
      width = "block",
      right_pad = 1,
    },
  },
}
