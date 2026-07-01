return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Crucial for efficiency: loads only after the UI is fully drawn
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    -- This is independent of your vim.opt.timeoutlen (which is 500ms).
    -- If you type fast, the popup will not show and use 0 CPU.
    delay = 400,
    
    -- Here we register nice names for the keymap prefixes you already have.
    -- This doesn't map the keys, it just tells which-key what to call the groups in the popup.
    spec = {
      { "<leader>c", group = "Code Action", mode = { "n", "x" } },
      { "<leader>d", group = "Diagnostics/Document" },
      { "<leader>e", group = "Explorer (Yazi)" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>r", group = "Rename" },
      { "<leader>s", group = "Split/Save" },
      { "<leader>t", group = "Tabs/Toggle" },
      { "<leader>w", group = "Workspace" },
      { "<leader>x", group = "Close" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
