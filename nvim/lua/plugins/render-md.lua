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
    bullet = {
      right_pad = 0,
    },
    code = {
      width = "block",
      right_pad = 1,
    },
  },
  config = function(_, opts)
    -- 1. Initialize the plugin with your opts
    require("render-markdown").setup(opts)
    
    -- 2. Override the code block background to be completely transparent
    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1B1E28" })
    
    -- (Optional) If you also want to clear the inline code background, uncomment the line below:
    -- vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "NONE" })
  end,
}
