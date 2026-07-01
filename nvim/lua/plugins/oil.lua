return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  
  -- Lazy-load on the keymaps or when opening a directory directly
  cmd = "Oil",
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = "Open File Explorer (Oil)" },
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  
  opts = {
    -- Oil will completely replace netrw (Neovim's default file explorer)
    default_file_explorer = true,
    
    -- Customize some default viewing options
    view_options = {
      show_hidden = true, -- Show hidden (dot) files by default
      is_always_hidden = function(name, bufnr)
        return name == ".." -- Hide the '..' directory since we can use '-' to go up
      end,
    },
    
    -- Float configuration if you want it to look like a popup (optional)
    -- Setting to false means it opens in the current window like a normal buffer
    float = {
      padding = 2,
      max_width = 120,
      max_height = 40,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
  },
}
