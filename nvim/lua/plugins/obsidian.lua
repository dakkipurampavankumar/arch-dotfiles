return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown", 
  
  -- Add this section: 
  -- Lazy will intercept these commands and load the plugin on-the-fly
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianToday",
    "ObsidianSearch",
  },
  
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal", -- Ensure this directory actually exists on your system!
      },
    },
    ui = {
      enable = false, -- Disable obsidian's UI so render-markdown can handle everything consistently
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Re-trigger filetype and explicitly start treesitter / render-markdown
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md",
      callback = function(ev)
        vim.schedule(function()
          -- Ensure the filetype is set to markdown so plugins know what to do
          vim.bo[ev.buf].filetype = "markdown"
          -- Force treesitter to start if it hasn't
          pcall(vim.treesitter.start, ev.buf, "markdown")
        end)
      end,
    })
  end,
}
