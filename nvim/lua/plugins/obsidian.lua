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

    -- Safety net: ensure treesitter starts for markdown after obsidian loads
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.md",
      callback = function(ev)
        vim.schedule(function()
          -- Only force-start treesitter if it didn't auto-start
          if not vim.treesitter.highlighter.active[ev.buf] then
            pcall(vim.treesitter.start, ev.buf, "markdown")
          end
        end)
      end,
    })
  end,
}
