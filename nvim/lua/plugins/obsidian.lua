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
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal", -- Ensure this directory actually exists on your system!
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
    },
  },
}
